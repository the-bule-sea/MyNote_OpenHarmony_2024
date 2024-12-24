package xyz.ifilk.note_sync_server.config

import io.swagger.v3.oas.models.OpenAPI
import io.swagger.v3.oas.models.info.Contact
import io.swagger.v3.oas.models.info.Info
import io.swagger.v3.oas.models.info.License
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration


@Configuration
class SwaggerConfig {
    @Bean
    fun apiInfo(): OpenAPI {
        return OpenAPI()
            .info(
                Info().title("MyNote 云同步服务器API文档")
                    .contact(Contact().apply {
                        name = "Ifilk"
                        url = "https://github.com/Ifilk"
                        email = "ifilk@yeah.net"
                    })
                    .description("MyNote 云同步服务器 RESTfui API文档")
                    .version("v1.0.0")
                    .license(License().name("Apache 2.0").url("http://springdoc.org"))
            )

    }
}