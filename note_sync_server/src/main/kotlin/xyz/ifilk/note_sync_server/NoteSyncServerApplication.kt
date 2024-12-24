package xyz.ifilk.note_sync_server

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.cache.annotation.EnableCaching
import org.springframework.data.jpa.repository.config.EnableJpaAuditing
import org.springframework.scheduling.annotation.EnableScheduling

@SpringBootApplication
@EnableJpaAuditing
@EnableScheduling
@EnableCaching
open class NoteSyncServerApplication

fun main(args: Array<String>) {
    runApplication<NoteSyncServerApplication>(*args)
}
