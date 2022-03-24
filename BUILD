package(default_visibility = ["//visibility:private"])

java_binary(
    name = "mybuilder",
    main_class = "com.salesforce.bazel.javabuilder.mybuilder.MyBuilderInvoker",
    visibility = ["//visibility:public"],
    runtime_deps = [
    	"//src/main/java/com/salesforce/bazel/javabuilder/mybuilder",
    ],
    jvm_flags = [
        #"-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=8000"
    ]
)