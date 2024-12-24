package xyz.ifilk.note_sync_server.model

import io.swagger.v3.oas.annotations.media.Schema
import xyz.ifilk.note_sync_server.entity.Note
import java.io.Serializable
import java.time.Instant
import java.util.*

/**
 * DTO for {@link xyz.ifilk.note_sync_server.entity.Note}
 */
data class NoteDto(
    @field:Schema(name = "id", description = "笔记ID")
    val id: String? = null,
    @field:Schema(name = "title", description = "笔记标题")
    val title: String? = null,
    @field:Schema(name = "content", description = "笔记正文")
    val content: String? = null,
    @field:Schema(name = "ownerId", description = "所有者（用户ID）")
    val ownerId: String? = null,
    @field:Schema(name = "lastModifiedDate", description = "上一次编辑时间")
    val lastModifiedDate: Instant? = null,
    @field:Schema(name = "createdDate", description = "创建时间")
    val createdDate: Instant? = null
) : Serializable {
    companion object {
        fun fromNote(note: Note): NoteDto {
            return NoteDto(
                note.id.toString(),
                note.title,
                note.content,
                note.owner!!.id!!.toString(),
                note.lastModifiedDate,
                note.createdDate
            )
        }
    }
}