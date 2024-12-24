package xyz.ifilk.note_sync_server.controller
import cn.dev33.satoken.exception.NotLoginException
import jakarta.servlet.http.HttpServletRequest
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.ControllerAdvice
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.web.bind.annotation.ResponseBody
import org.springframework.web.bind.annotation.ResponseStatus
import xyz.ifilk.note_sync_server.exception.*

@ControllerAdvice
@ResponseBody
class ExceptionController {
    private var log: Logger = LoggerFactory.getLogger(ExceptionController::class.java)

//    @ExceptionHandler(MethodArgumentNotValidException::class)
//    fun handleMethodArgumentNotValidException(e: MethodArgumentNotValidException): SaResult{
//        log.warn("Exception: ", e)
//        return SaResult.error(e.allErrors.stream().map { it.defaultMessage }.collect(Collectors.joining(";")))
//    }

    @ExceptionHandler(
        NullPointerException::class,
        DuplicateUserNameException::class,
        NoteNotFound::class,
        UserNotFound::class,
        VerificationException::class
    )
    @ResponseStatus(code = HttpStatus.BAD_REQUEST, reason = "请求参数异常!")
    fun handleBadRequestException(request: HttpServletRequest?, e: Exception): String? {
        log.warn("Exception: ", e)
        return e.message
    }

    @ExceptionHandler(
        UnAuthorized::class
    )
    @ResponseStatus(code = HttpStatus.UNAUTHORIZED, reason = "未授权")
    fun handleUnAuthorizedException(request: HttpServletRequest?, e: Exception): String? {
        log.warn("Exception: ", e)
        return e.message
    }

    @ExceptionHandler(
        NotLoginException::class
    )
    @ResponseStatus(code = HttpStatus.UNAUTHORIZED, reason = "未授权")
    fun handleUnAuthorizationException(request: HttpServletRequest?, e: Exception): String? {
        return e.message
    }
}
