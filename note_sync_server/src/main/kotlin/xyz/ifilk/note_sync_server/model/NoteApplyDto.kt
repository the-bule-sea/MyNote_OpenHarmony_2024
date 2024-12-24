package xyz.ifilk.note_sync_server.model

import jakarta.validation.constraints.NotNull
import java.io.Serializable

/**
 * DTO for {@link xyz.ifilk.note_sync_server.entity.Note}
 */
data class NoteApplyDto(@field:NotNull val content: String? = null, @field:NotNull val title: String? = null) :
    Serializable