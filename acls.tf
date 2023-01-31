resource "confluent_kafka_acl" "microservice-producer-write-on-topic" {
  kafka_cluster {
    id = confluent_kafka_cluster.dev-cluster.id
  }
  resource_type = "TOPIC"
  resource_name = confluent_kafka_topic.to_rabbit.topic_name
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.microservice-producer.id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.dev-cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "microservice-consumer-read-on-topic" {
  kafka_cluster {
    id = confluent_kafka_cluster.dev-cluster.id
  }
  resource_type = "TOPIC"
  resource_name = confluent_kafka_topic.from_rabbit.topic_name
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.microservice-consumer.id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.dev-cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "microservice-consumer-read-on-group" {
  kafka_cluster {
    id = confluent_kafka_cluster.dev-cluster.id
  }
  resource_type = "GROUP"
  // The existing values of resource_name, pattern_type attributes are set up to match Confluent CLI's default consumer group ID ("confluent_cli_consumer_<uuid>").
  // https://docs.confluent.io/confluent-cli/current/command-reference/kafka/topic/confluent_kafka_topic_consume.html
  // Update the values of resource_name, pattern_type attributes to match your target consumer group ID.
  // https://docs.confluent.io/platform/current/kafka/authorization.html#prefixed-acls
  resource_name = "confluent_cli_consumer_"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.microservice-consumer.id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.dev-cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "rabbit-src-write-on-topic" {
  kafka_cluster {
    id = confluent_kafka_cluster.dev-cluster.id
  }
  resource_type = "TOPIC"
  resource_name = confluent_kafka_topic.from_rabbit.topic_name
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.rabbit-src.id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.dev-cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "rabbit-dest-read-on-topic" {
  kafka_cluster {
    id = confluent_kafka_cluster.dev-cluster.id
  }
  resource_type = "TOPIC"
  resource_name = confluent_kafka_topic.to_rabbit.topic_name
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.rabbit-dest.id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.dev-cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "rabbit-dest-read-on-group" {
  kafka_cluster {
    id = confluent_kafka_cluster.dev-cluster.id
  }
  resource_type = "GROUP"
  // The existing values of resource_name, pattern_type attributes are set up to match Confluent CLI's default consumer group ID ("confluent_cli_consumer_<uuid>").
  // https://docs.confluent.io/confluent-cli/current/command-reference/kafka/topic/confluent_kafka_topic_consume.html
  // Update the values of resource_name, pattern_type attributes to match your target consumer group ID.
  // https://docs.confluent.io/platform/current/kafka/authorization.html#prefixed-acls
  resource_name = "confluent_cli_consumer_"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.rabbit-dest.id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.dev-cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "rabbit-src-describe-on-cluster" {
  kafka_cluster {
    id = confluent_kafka_cluster.dev-cluster.id
  }
  resource_type = "CLUSTER"
  resource_name = "kafka-cluster"
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.rabbit-src.id}"
  host          = "*"
  operation     = "DESCRIBE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.dev-cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "rabbit-src-create-topic" {
  kafka_cluster {
    id = confluent_kafka_cluster.dev-cluster.id
  }
  resource_type = "TOPIC"
  resource_name = confluent_kafka_topic.from_rabbit.topic_name
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.rabbit-src.id}"
  host          = "*"
  operation     = "CREATE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.dev-cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
}
