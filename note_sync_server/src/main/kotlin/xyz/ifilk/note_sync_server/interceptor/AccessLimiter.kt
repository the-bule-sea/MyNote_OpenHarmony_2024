package xyz.ifilk.note_sync_server.interceptor

import cn.hutool.cache.Cache
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Component
import java.util.concurrent.atomic.AtomicInteger

@Component
class AccessLimiter {
    private var cache: Cache<String, AtomicInteger>? = null

    @Value("\${limiter.ip-limit}")
    private val capacity: Long = 0
    @Autowired
    fun setLimiterCache(cache: Cache<String, AtomicInteger>) {
        this.cache = cache
    }

    fun access(ip: String?): Boolean {
        var a: AtomicInteger? = null
        return if (cache?.get(ip).also {
                if (it != null) {
                    a = it
                }
            } == null) {
            cache?.put(ip, AtomicInteger(1))
            true
        } else {
            if (a?.get()!! <= capacity) {
                a?.incrementAndGet()
                true
            } else false
        }
    }
}
