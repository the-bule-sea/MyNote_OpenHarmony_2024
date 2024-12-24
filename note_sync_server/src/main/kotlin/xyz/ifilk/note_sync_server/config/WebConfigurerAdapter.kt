package xyz.ifilk.note_sync_server.config

import cn.dev33.satoken.interceptor.SaInterceptor
import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.Configuration
import org.springframework.web.servlet.config.annotation.InterceptorRegistry
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer
import xyz.ifilk.note_sync_server.interceptor.AccessLimitInterceptor


@Configuration
class WebConfigurerAdapter(
    private var accessLimitInterceptor: AccessLimitInterceptor
): WebMvcConfigurer {

    @Value("\${web.upload-path}")
    private val uploadPath: String? = null

    override fun addInterceptors(registry: InterceptorRegistry) {
        registry.addInterceptor(accessLimitInterceptor).addPathPatterns("/**")
        registry.addInterceptor(SaInterceptor()).addPathPatterns("/api/**")
    }

    override fun addResourceHandlers(registry: ResourceHandlerRegistry) {
        registry.addResourceHandler("/api/res/**").addResourceLocations("file:$uploadPath/")
        super.addResourceHandlers(registry)
    }
}