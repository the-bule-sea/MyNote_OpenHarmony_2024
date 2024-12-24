package xyz.ifilk.note_sync_server.interceptor

import org.springframework.beans.factory.annotation.Value
import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Component

@Component
class AccessLimiterBucket {
    @Value("\${limiter.capacity}")
    private var capacity: Long = 0

    private var currentQuantity: Long = 0

    @get:Synchronized
    val token: Boolean
        get() = if ((0 < currentQuantity) and (currentQuantity <= capacity)) {
            currentQuantity--
            true
        } else false

    @Scheduled(fixedRate = 10)
    fun putToken() {
        if (currentQuantity < capacity) currentQuantity++
    }
}
