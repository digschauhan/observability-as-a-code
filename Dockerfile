ARG VERSION=0.0.1
ARG APP_NAME=observability-as-a-code
ARG NR_API_KEY

FROM amazoncorretto:23-alpine3.21-jdk AS builder

ARG VERSION
ARG APP_NAME

WORKDIR /app
COPY . ./

RUN ./gradlew clean build
COPY build/libs/${APP_NAME}-${VERSION}.jar /app/target/app.jar
COPY libs/opentelemetry-javaagent.jar /app/target/opentelemetry-javaagent.jar

RUN ls -ltr /app/build/libs

#===================================================================================================
FROM amazoncorretto:23-alpine3.21-jdk AS runner

ARG APP_NAME
ARG NR_API_KEY

COPY --from=builder /app/target/*.jar /app/

ENV JAVA_TOOL_OPTIONS="-javaagent:/app/opentelemetry-javaagent.jar"
ENV OTEL_SERVICE_NAME=${APP_NAME}

ENV OTEL_RESOURCE_ATTRIBUTES=service.instance.id=observability-as-a-code
ENV OTEL_EXPORTER_OTLP_ENDPOINT=https://otlp.nr-data.net:4317
ENV OTEL_EXPORTER_OTLP_HEADERS=api-key=${NR_API_KEY}
ENV OTEL_ATTRIBUTE_VALUE_LENGTH_LIMIT=4095
ENV OTEL_EXPORTER_OTLP_COMPRESSION=gzip
ENV OTEL_EXPORTER_OTLP_PROTOCOL=http/protobuf 
ENV OTEL_EXPORTER_OTLP_METRICS_TEMPORALITY_PREFERENCE=delta

EXPOSE 8080

ENTRYPOINT [ "java", "-jar", "/app/app.jar" ]
