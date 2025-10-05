package com.devops.vitrine.config;

import io.micrometer.core.instrument.MeterRegistry;
import io.opentelemetry.api.OpenTelemetry;
import io.opentelemetry.api.common.Attributes;
import io.opentelemetry.api.trace.propagation.W3CTraceContextPropagator;
import io.opentelemetry.context.propagation.ContextPropagators;
import io.opentelemetry.exporter.otlp.logs.OtlpGrpcLogRecordExporter;
import io.opentelemetry.exporter.otlp.metrics.OtlpGrpcMetricExporter;
import io.opentelemetry.exporter.otlp.trace.OtlpGrpcSpanExporter;
import io.opentelemetry.sdk.OpenTelemetrySdk;
import io.opentelemetry.sdk.logs.SdkLoggerProvider;
import io.opentelemetry.sdk.logs.export.BatchLogRecordProcessor;
import io.opentelemetry.sdk.metrics.SdkMeterProvider;
import io.opentelemetry.sdk.metrics.export.PeriodicMetricReader;
import io.opentelemetry.sdk.resources.Resource;
import io.opentelemetry.sdk.trace.SdkTracerProvider;
import io.opentelemetry.sdk.trace.export.BatchSpanProcessor;
import io.opentelemetry.semconv.ResourceAttributes;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.Duration;

/**
 * Configuration OpenTelemetry pour l'observabilité complète
 * Traces, Métriques et Logs envoyés au OpenTelemetry Collector
 */
@Configuration
public class ObservabilityConfig {

    @Value("${spring.application.name:vitrine-backend}")
    private String serviceName;

    @Value("${otel.exporter.otlp.endpoint:http://localhost:4317}")
    private String otlpEndpoint;

    @Value("${deployment.environment:dev}")
    private String environment;

    /**
     * Ressource OpenTelemetry avec les attributs du service
     */
    @Bean
    public Resource otelResource() {
        return Resource.getDefault()
                .merge(Resource.create(
                        Attributes.builder()
                                .put(ResourceAttributes.SERVICE_NAME, serviceName)
                                .put(ResourceAttributes.SERVICE_VERSION, "1.0.0")
                                .put(ResourceAttributes.DEPLOYMENT_ENVIRONMENT, environment)
                                .build()
                ));
    }

    /**
     * Exporter OTLP pour les traces
     */
    @Bean
    public OtlpGrpcSpanExporter otlpSpanExporter() {
        return OtlpGrpcSpanExporter.builder()
                .setEndpoint(otlpEndpoint)
                .setTimeout(Duration.ofSeconds(10))
                .build();
    }

    /**
     * Exporter OTLP pour les métriques
     */
    @Bean
    public OtlpGrpcMetricExporter otlpMetricExporter() {
        return OtlpGrpcMetricExporter.builder()
                .setEndpoint(otlpEndpoint)
                .setTimeout(Duration.ofSeconds(10))
                .build();
    }

    /**
     * Exporter OTLP pour les logs
     */
    @Bean
    public OtlpGrpcLogRecordExporter otlpLogExporter() {
        return OtlpGrpcLogRecordExporter.builder()
                .setEndpoint(otlpEndpoint)
                .setTimeout(Duration.ofSeconds(10))
                .build();
    }

    /**
     * Tracer Provider pour les traces distribuées
     */
    @Bean
    public SdkTracerProvider sdkTracerProvider(
            Resource resource,
            OtlpGrpcSpanExporter spanExporter) {
        return SdkTracerProvider.builder()
                .setResource(resource)
                .addSpanProcessor(BatchSpanProcessor.builder(spanExporter)
                        .setScheduleDelay(Duration.ofSeconds(5))
                        .build())
                .build();
    }

    /**
     * Meter Provider pour les métriques
     */
    @Bean
    public SdkMeterProvider sdkMeterProvider(
            Resource resource,
            OtlpGrpcMetricExporter metricExporter) {
        return SdkMeterProvider.builder()
                .setResource(resource)
                .registerMetricReader(
                        PeriodicMetricReader.builder(metricExporter)
                                .setInterval(Duration.ofSeconds(15))
                                .build())
                .build();
    }

    /**
     * Logger Provider pour les logs
     */
    @Bean
    public SdkLoggerProvider sdkLoggerProvider(
            Resource resource,
            OtlpGrpcLogRecordExporter logExporter) {
        return SdkLoggerProvider.builder()
                .setResource(resource)
                .addLogRecordProcessor(
                        BatchLogRecordProcessor.builder(logExporter)
                                .setScheduleDelay(Duration.ofSeconds(5))
                                .build())
                .build();
    }

    /**
     * OpenTelemetry SDK principal
     */
    @Bean
    public OpenTelemetry openTelemetry(
            SdkTracerProvider tracerProvider,
            SdkMeterProvider meterProvider,
            SdkLoggerProvider loggerProvider) {
        return OpenTelemetrySdk.builder()
                .setTracerProvider(tracerProvider)
                .setMeterProvider(meterProvider)
                .setLoggerProvider(loggerProvider)
                .setPropagators(ContextPropagators.create(W3CTraceContextPropagator.getInstance()))
                .buildAndRegisterGlobal();
    }
}
