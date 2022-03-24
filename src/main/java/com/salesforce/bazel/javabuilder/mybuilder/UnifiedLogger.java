package com.salesforce.bazel.javabuilder.mybuilder;

import java.lang.reflect.Field;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.spi.LocationAwareLogger;

/**
 * A singleton logger for easier configuration with SLF4J's Simple System.out implementation.
 * <p>
 * This logger is particular applicable for command line applications. It's use is encouraged globally where no
 * differentiation between different logger is necessary and a global debug flag is sufficient.
 * </p>
 */
public class UnifiedLogger {

    private static final Logger LOG = LoggerFactory.getLogger("com.salesforce.bazel");

    public static void enableDebugLogging() {
        try {
            Field field = LOG.getClass().getDeclaredField("currentLogLevel");
            field.setAccessible(true);
            field.set(LOG, LocationAwareLogger.DEBUG_INT);
        } catch (IllegalArgumentException | IllegalAccessException | NoSuchFieldException | SecurityException e) {
            LOG.warn("Unable to configure verbose logging. {}", e.getMessage(), e);
        }
    }

    public static Logger getLogger() {
        return LOG;
    }

}
