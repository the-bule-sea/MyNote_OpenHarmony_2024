package xyz.ifilk.note_sync_server.service

import org.springframework.stereotype.Service
import xyz.ifilk.note_sync_server.entity.User
import xyz.ifilk.note_sync_server.exception.DuplicateUserNameException
import xyz.ifilk.note_sync_server.exception.UserLoginVerifyException
import xyz.ifilk.note_sync_server.exception.UserNotFound
import xyz.ifilk.note_sync_server.repository.UserRepository
import java.util.UUID

@Service
class UserServerImpl(private val userRepository: UserRepository) {
    fun login(username: String, password: String): UUID{
        val user = userRepository.findByUserName(username).orElseThrow{ UserNotFound() }
        if (!user.verifyPassword(password))
            throw UserLoginVerifyException()
        return user.id!!
    }

    fun register(username: String, password: String): String {
        userRepository.findByUserName(username).ifPresent {
            throw DuplicateUserNameException()
        }

        return userRepository.save(User().apply {
            this.userName = username
            this.setPassword(password)
        }).id.toString()
    }
}