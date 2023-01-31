resource "confluent_api_key" "microservice-consumer" {
  display_name = "microservice-consumer-kafka-api-key"
  description  = "Kafka API Key that is owned by 'app-consumer' service account"
  owner {
    id          = confluent_service_account.microservice-consumer.id
    api_version = confluent_service_account.microservice-consumer.api_version
    kind        = confluent_service_account.microservice-consumer.kind
  }
}

resource "confluent_api_key" "microservice-producer" {
  display_name = "microservice-consumer-kafka-api-key"
  description  = "Kafka API Key that is owned by 'app-consumer' service account"
  owner {
    id          = confluent_service_account.microservice-producer.id
    api_version = confluent_service_account.microservice-producer.api_version
    kind        = confluent_service_account.microservice-producer.kind
  }
}

resource "confluent_api_key" "rabbit-src" {
  display_name = "rabbit-src-kafka-api-key"
  description  = "Kafka API Key that is owned by 'app-consumer' service account"
  owner {
    id          = confluent_service_account.rabbit-src.id
    api_version = confluent_service_account.rabbit-src.api_version
    kind        = confluent_service_account.rabbit-src.kind
  }
}

resource "confluent_api_key" "rabbit-dest" {
  display_name = "rabbit-dest-kafka-api-key"
  description  = "Kafka API Key that is owned by 'app-consumer' service account"
  owner {
    id          = confluent_service_account.rabbit-dest.id
    api_version = confluent_service_account.rabbit-dest.api_version
    kind        = confluent_service_account.rabbit-dest.kind
  }
}