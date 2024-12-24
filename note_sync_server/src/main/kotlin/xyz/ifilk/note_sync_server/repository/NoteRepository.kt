package xyz.ifilk.note_sync_server.repository

import org.springframework.data.repository.CrudRepository
import xyz.ifilk.note_sync_server.entity.Note
import java.util.*

interface NoteRepository : CrudRepository<Note, UUID> {
}