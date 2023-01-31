resource "random_id" "id" {
    byte_length = 4
}

resource "confluent_environment" "dev_env" {
  display_name = "dev_env-${random_id.id.hex}"
  lifecycle {
    prevent_destroy = false
  }
}

data "confluent_schema_registry_region" "dev_sr_region" {
    cloud = "AWS"
    region = "eu-central-1"
    package = "ESSENTIALS"
}

resource "confluent_schema_registry_cluster" "dev_sr_cluster" {
    package = data.confluent_schema_registry_region.dev_sr_region.package
    environment {
        id = confluent_environment.dev_env.id
    }
    region {
        id = data.confluent_schema_registry_region.dev_sr_region.id
    }
  
}

resource "confluent_kafka_cluster" "dev-cluster" {
  display_name = "dev-cluster"
  availability = "MULTI_ZONE"
  cloud        = "AWS"
  region       = "eu-central-1"
  standard {}
  environment {
    id = confluent_environment.dev_env.id
  }
}

resource "confluent_service_account" "app-manager" {
  display_name = "app-manager"
  description  = "Service account to manage 'inventory' Kafka cluster"
}

resource "confluent_role_binding" "app-manager-kafka-cluster-admin" {
  principal   = "User:${confluent_service_account.app-manager.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.dev-cluster.rbac_crn
}

resource "confluent_api_key" "app-manager-kafka-api-key" {
  display_name = "app-manager-kafka-api-key"
  description  = "Kafka API Key that is owned by 'app-manager' service account"
  owner {
    id          = confluent_service_account.app-manager.id
    api_version = confluent_service_account.app-manager.api_version
    kind        = confluent_service_account.app-manager.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.dev-cluster.id
    api_version = confluent_kafka_cluster.dev-cluster.api_version
    kind        = confluent_kafka_cluster.dev-cluster.kind

    environment {
      id = confluent_environment.dev_env.id
    }
  }

  # The goal is to ensure that confluent_role_binding.app-manager-kafka-cluster-admin is created before
  # confluent_api_key.app-manager-kafka-api-key is used to create instances of
  # confluent_kafka_topic, confluent_kafka_acl resources.

  # 'depends_on' meta-argument is specified in confluent_api_key.app-manager-kafka-api-key to avoid having
  # multiple copies of this definition in the configuration which would happen if we specify it in
  # confluent_kafka_topic, confluent_kafka_acl resources instead.
  depends_on = [
    confluent_role_binding.app-manager-kafka-cluster-admin
  ]
}

resource "confluent_kafka_topic" "to_rabbit" {
  kafka_cluster {
    id = confluent_kafka_cluster.dev-cluster.id
  }
  topic_name    = "to_rabbit"
  rest_endpoint = confluent_kafka_cluster.dev-cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}

resource "confluent_kafka_topic" "from_rabbit" {
  kafka_cluster {
    id = confluent_kafka_cluster.dev-cluster.id
  }
  topic_name    = "from_rabbit"
  rest_endpoint = confluent_kafka_cluster.dev-cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}

