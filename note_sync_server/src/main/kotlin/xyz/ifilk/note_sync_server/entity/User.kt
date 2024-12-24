package xyz.ifilk.note_sync_server.entity

import jakarta.persistence.*
import xyz.ifilk.note_sync_server.common.HashUtil
import java.util.*

@Entity
@Table(name = "users")
class User {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "id", nullable = false)
    var id: UUID? = null

    @Column(name = "user_name", unique = true)
    var userName: String? = null

    @Column(name = "hashed_password")
    var hashedPassword: String? = null

    @Column(name = "salt", length = 6)
    var salt: String? = null

    @OneToMany(mappedBy = "owner", orphanRemoval = true, cascade = [CascadeType.ALL], fetch = FetchType.LAZY)
    var notes: MutableList<Note> = mutableListOf()

    fun setPassword(password: String) {
        this.salt = HashUtil.generateSalt()
        this.hashedPassword = HashUtil.hashPassword(password, this.salt!!)
    }

    fun verifyPassword(password: String): Boolean {
        return HashUtil.verifyPassword(password, this.salt!!, this.hashedPassword!!)
    }
}