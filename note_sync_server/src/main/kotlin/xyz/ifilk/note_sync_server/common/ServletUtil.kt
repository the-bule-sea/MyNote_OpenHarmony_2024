package xyz.ifilk.note_sync_server.common

import cn.hutool.core.net.NetUtil
import cn.hutool.core.util.ArrayUtil
import jakarta.servlet.http.HttpServletRequest

object ServletUtil {
    fun getClientIP(request: HttpServletRequest?): String? {
        val headers = arrayOf(
            "X-Forwarded-For",
            "X-Real-IP",
            "Proxy-Client-IP",
            "WL-Proxy-Client-IP",
            "HTTP_CLIENT_IP",
            "HTTP_X_FORWARDED_FOR"
        )
        return request?.let { getClientIPByHeader(it, headers) }
    }

    private fun getClientIPByHeader(request: HttpServletRequest, headerNames: Array<String>): String? {
        var ip: String?
        for (header in headerNames) {
            ip = request.getHeader(header)
            if (!NetUtil.isUnknown(ip)) {
                return NetUtil.getMultistageReverseProxyIp(ip)
            }
        }
        ip = request.remoteAddr
        return NetUtil.getMultistageReverseProxyIp(ip)
    }
}