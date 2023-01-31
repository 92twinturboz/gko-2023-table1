resource "confluent_service_account" "microservice-producer" {
  display_name = "microservice-producer"
  description  = "Service account to consume from 'orders' topic of 'inventory' Kafka cluster"
}

resource "confluent_service_account" "microservice-consumer" {
  display_name = "microservice-consumer"
  description  = "Service account to consume from 'orders' topic of 'inventory' Kafka cluster"
}

resource "confluent_service_account" "rabbit-src" {
  display_name = "rabbit-src"
  description  = "Service account to consume from 'orders' topic of 'inventory' Kafka cluster"
}

resource "confluent_service_account" "rabbit-dest" {
  display_name = "rabbit-dest"
  description  = "Service account to consume from 'orders' topic of 'inventory' Kafka cluster"
}