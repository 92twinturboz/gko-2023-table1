resource "confluent_connector" "mq-src" {
  environment {
    id = confluent_environment.dev_env.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.dev-cluster.id
  }

  // Block for custom *sensitive* configuration properties that are labelled with "Type: password" under "Configuration Properties" section in the docs:
  // https://docs.confluent.io/cloud/current/connectors/cc-datagen-source.html#configuration-properties
  config_sensitive = {
    "rabbitmq.password" : "mypassword"
  }

  // Block for custom *nonsensitive* configuration properties that are *not* labelled with "Type: password" under "Configuration Properties" section in the docs:
  // https://docs.confluent.io/cloud/current/connectors/cc-datagen-source.html#configuration-properties
  config_nonsensitive = {
    "connector.class": "RabbitMQSource"
     "name": "RabbitMQSource"
     "kafka.auth.mode": "SERVICE_ACCOUNT"
     "kafka.service.account.id" = confluent_service_account.rabbit-src.id
     "kafka.topic": confluent_kafka_topic.from_rabbit.topic_name
     "rabbitmq.host" : "$NGROK_HOSTNAME"
     "rabbitmq.port" : "$NGROK_PORT"
     "rabbitmq.username": "myuser"
     "rabbitmq.queue": "myqueue"
     "tasks.max" : "1"
  }

  depends_on = [
    confluent_kafka_acl.rabbit-src-describe-on-cluster,
    confluent_kafka_acl.rabbit-src-write-on-topic,
    confluent_kafka_acl.rabbit-src-create-topic
  ]
}

resource "confluent_connector" "mq-sink" {
  environment {
    id = confluent_environment.dev_env.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.dev-cluster.id
  }

  // Block for custom *sensitive* configuration properties that are labelled with "Type: password" under "Configuration Properties" section in the docs:
  // https://docs.confluent.io/cloud/current/connectors/cc-datagen-source.html#configuration-properties
  config_sensitive = {
    "rabbitmq.password" : "mypassword"
  }

  // Block for custom *nonsensitive* configuration properties that are *not* labelled with "Type: password" under "Configuration Properties" section in the docs:
  // https://docs.confluent.io/cloud/current/connectors/cc-datagen-source.html#configuration-properties
  config_nonsensitive = {
    "connector.class": "RabbitMQSink"
     "name": "RabbitMQSink"
     "kafka.auth.mode": "SERVICE_ACCOUNT"
     "kafka.service.account.id" = confluent_service_account.rabbit-dest.id
     "kafka.topic": confluent_kafka_topic.to_rabbit.topic_name
     "rabbitmq.host" : "192.168.1.99",
     "rabbitmq.exchange" : "exchange_1",
     "rabbitmq.routing.key" : "routingkey_1",
     "rabbitmq.delivery.mode" : "PERSISTENT",
     "tasks.max" : "1"

  }

  depends_on = [
    confluent_kafka_acl.rabbit-src-describe-on-cluster,
    confluent_kafka_acl.rabbit-src-write-on-topic,
    confluent_kafka_acl.rabbit-src-create-topic
  ]
}