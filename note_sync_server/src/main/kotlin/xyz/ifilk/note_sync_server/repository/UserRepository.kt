package xyz.ifilk.note_sync_server.repository

import org.springframework.data.repository.CrudRepository
import xyz.ifilk.note_sync_server.entity.User
import java.util.*

interface UserRepository : CrudRepository<User, UUID> {


    fun findByUserName(userName: String): Optional<User>
}