package xyz.ifilk.note_sync_server.entity

import jakarta.persistence.*
import org.hibernate.proxy.HibernateProxy
import org.springframework.data.annotation.CreatedDate
import org.springframework.data.annotation.LastModifiedDate
import java.time.Instant
import java.util.*

@EntityListeners(org.springframework.data.jpa.domain.support.AuditingEntityListener::class)
@Entity
@Table(name = "notes")
class Note {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "id", nullable = false)
    var id: UUID? = null

    @Lob
    @Column(name = "content")
    var content: String? = null

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    var owner: User? = null

    @LastModifiedDate
    @Column(name = "last_modified_date")
    var lastModifiedDate: Instant? = null

    @CreatedDate
    @Column(name = "created_date")
    var createdDate: Instant? = null

    @Column(name = "title")
    var title: String? = null

    final override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (other == null) return false
        val oEffectiveClass =
            if (other is HibernateProxy) other.hibernateLazyInitializer.persistentClass else other.javaClass
        val thisEffectiveClass =
            if (this is HibernateProxy) this.hibernateLazyInitializer.persistentClass else this.javaClass
        if (thisEffectiveClass != oEffectiveClass) return false
        other as Note

        return id != null && id == other.id
    }

    final override fun hashCode(): Int =
        if (this is HibernateProxy) this.hibernateLazyInitializer.persistentClass.hashCode() else javaClass.hashCode()
}