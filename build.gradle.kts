// Top-level build file where you can add configuration options common to all sub-projects/modules.
buildscript {
    repositories {
        // PG_CHANGED: maven("https://plugins.gradle.org/m2/")
        maven {
            url = uri("https://plugins.gradle.org/m2/")
        }
        // PG_CHANGED: google()
        maven {
            url = uri("https://maven.google.com/")
        }
        // PG_CHANGED: mavenCentral()
        maven {
            url = uri("https://repo1.maven.org/maven2/")
        }
    }

    // PG_CHANGED: needed to generate lockfile
    // cmd: ./gradlew :lib:buildEnvironment --write-locks
    configurations.all {
        resolutionStrategy.activateDependencyLocking()
    }
}

plugins {
    id("com.android.library") version DependenciesVersions.androidGradlePlugin apply false
    id("org.jetbrains.kotlin.android") version DependenciesVersions.kotlin apply false
    id("org.jetbrains.kotlin.jvm") version DependenciesVersions.kotlin apply false
    id("io.github.gradle-nexus.publish-plugin") version DependenciesVersions.nexusPublishGradlePlugin
}

apply(from = "${rootDir}/scripts/publish-root.gradle")


tasks.register<Delete>("clean").configure {
    delete(rootProject.layout.buildDirectory)
 }

 

