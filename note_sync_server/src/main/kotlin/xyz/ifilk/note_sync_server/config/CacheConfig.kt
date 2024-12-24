package xyz.ifilk.note_sync_server.config

import cn.hutool.cache.Cache
import cn.hutool.cache.CacheUtil
import cn.hutool.core.date.DateUnit
import com.github.benmanes.caffeine.cache.Caffeine
import org.springframework.cache.CacheManager
import org.springframework.cache.caffeine.CaffeineCacheManager
import org.springframework.context.annotation.Bean
import org.springframework.stereotype.Component
import java.util.concurrent.TimeUnit
import java.util.concurrent.atomic.AtomicInteger

@Component
class CacheConfig {
    @Bean
    fun getLimitedCache(): Cache<String, AtomicInteger> {
        return CacheUtil.newTimedCache(DateUnit.MINUTE.millis)
    }

    @Bean
    fun cacheManager(): CacheManager {
        return CaffeineCacheManager().apply {
            setCaffeine(
                Caffeine.newBuilder()
                .maximumSize(1000)
                .expireAfterWrite(10, TimeUnit.MINUTES))
        }
    }

}