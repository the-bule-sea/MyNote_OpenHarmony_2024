package xyz.ifilk.note_sync_server.common

import java.security.MessageDigest
import java.security.SecureRandom
import java.util.Base64

object HashUtil {
    private const val SALT_LENGTH = 16

    // 生成随机盐
    fun generateSalt(): String {
        val random = SecureRandom()
        val salt = ByteArray(SALT_LENGTH)
        random.nextBytes(salt)
        return Base64.getEncoder().encodeToString(salt)
    }

    // 使用 SHA-256 和盐生成密码哈希
    fun hashPassword(password: String, salt: String): String {
        val messageDigest = MessageDigest.getInstance("SHA-256")
        val input = password + salt
        val hashBytes = messageDigest.digest(input.toByteArray(Charsets.UTF_8))
        return Base64.getEncoder().encodeToString(hashBytes)
    }

    // 验证密码是否匹配
    fun verifyPassword(password: String, salt: String, hashedPassword: String): Boolean {
        val computedHash = hashPassword(password, salt)
        return computedHash == hashedPassword
    }
}
