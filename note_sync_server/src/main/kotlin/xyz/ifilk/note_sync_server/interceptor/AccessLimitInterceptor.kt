package xyz.ifilk.note_sync_server.interceptor


import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.springframework.stereotype.Component
import org.springframework.web.servlet.HandlerInterceptor
import xyz.ifilk.note_sync_server.common.ServletUtil

@Component
class AccessLimitInterceptor(var accessLimiter: AccessLimiter?, var accessLimiterBucket: AccessLimiterBucket?) : HandlerInterceptor{

    @Throws(Exception::class)
    override fun preHandle(request: HttpServletRequest, response: HttpServletResponse, handler: Any): Boolean {
        if (!accessLimiter!!.access(ServletUtil.getClientIP(request))) {
            response.writer.write("You are visiting our service too frequently")
            return false
        }
        if (!accessLimiterBucket!!.token) {
            response.writer.write("The server is busy")
            return false
        }
        return true
    }
}
