package xyz.ifilk.note_sync_server.controller

import cn.dev33.satoken.annotation.SaIgnore
import cn.dev33.satoken.stp.SaLoginModel
import cn.dev33.satoken.stp.StpUtil
import cn.hutool.captcha.CaptchaUtil
import cn.hutool.captcha.LineCaptcha
import cn.hutool.captcha.generator.RandomGenerator
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.Parameter
import io.swagger.v3.oas.annotations.Parameters
import io.swagger.v3.oas.annotations.enums.ParameterIn
import jakarta.servlet.http.HttpServletResponse
import org.springframework.web.bind.annotation.*
import xyz.ifilk.note_sync_server.exception.VerificationException
import xyz.ifilk.note_sync_server.service.UserServerImpl

@RestController
@CrossOrigin
class UserController(private val userServerImpl: UserServerImpl) {
    private var lineCaptcha: LineCaptcha? = null

    @GetMapping("/users/verification/img_code")
    @Operation(summary = "获取图形验证码")
    @SaIgnore
    fun registerUserCode(response: HttpServletResponse) {
        val randomGenerator = RandomGenerator("0123456789", 4)
        lineCaptcha = CaptchaUtil.createLineCaptcha(100, 30)
        response.contentType = "image/jpeg"
        response.setHeader("Pragma", "No-cache")
        lineCaptcha!!.generator = randomGenerator
        lineCaptcha!!.write(response.outputStream)
        response.outputStream.close()
    }

    @PostMapping("/users/{username}/login")
    @Operation(summary = "用户登录")
    @Parameters(
        Parameter(name = "username", description = "用户名", `in` = ParameterIn.PATH),
        Parameter(name = "password", description = "明文密码", `in` = ParameterIn.QUERY)
    )
    @SaIgnore
    fun login(@PathVariable("username") username: String, @RequestParam("password") password: String): String{
        val userId = userServerImpl.login(username, password)
        StpUtil.login(userId.toString(), SaLoginModel().setIsWriteHeader(true))
        return "ok"
    }

    @PostMapping("/users/{username}/register")
    @SaIgnore
    @Operation(summary = "用户注册")
    @Parameters(
        Parameter(name = "username", description = "用户名", `in` = ParameterIn.PATH),
        Parameter(name = "password", description = "明文密码", `in` = ParameterIn.QUERY),
        Parameter(name = "imgCode", description = "验证码", `in` = ParameterIn.QUERY)
    )
    fun register(@PathVariable("username") username: String,
                 @RequestParam("password") password: String,
                 @RequestParam("imgCode") imgCode: String): String {
        if (imgCode != lineCaptcha!!.code)
            throw VerificationException("Img Verification Code Error ${lineCaptcha!!.code}")

        return userServerImpl.register(username, password)
    }
}