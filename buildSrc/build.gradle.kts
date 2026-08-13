import org.gradle.kotlin.dsl.`kotlin-dsl`

plugins {
    `kotlin-dsl`
}

repositories {
    maven {
        url = uri("https://repo1.maven.org/maven2/")
    }
}