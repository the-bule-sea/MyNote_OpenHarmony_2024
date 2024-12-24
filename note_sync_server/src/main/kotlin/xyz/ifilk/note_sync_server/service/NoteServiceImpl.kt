package xyz.ifilk.note_sync_server.service

import org.springframework.cache.annotation.CacheEvict
import org.springframework.cache.annotation.CachePut
import org.springframework.cache.annotation.Cacheable
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import xyz.ifilk.note_sync_server.entity.Note
import xyz.ifilk.note_sync_server.exception.NoteNotFound
import xyz.ifilk.note_sync_server.exception.UnAuthorized
import xyz.ifilk.note_sync_server.exception.UserNotFound
import xyz.ifilk.note_sync_server.model.NoteDto
import xyz.ifilk.note_sync_server.repository.NoteRepository
import xyz.ifilk.note_sync_server.repository.UserRepository
import java.util.*

@Service
@Transactional
class NoteServiceImpl(
    private val userRepository: UserRepository,
    private val noteRepository: NoteRepository
) {
    @Cacheable(value = ["userNotes"], key = "#root.methodName + #userId", unless = "#result.isEmpty()")
    fun getNotesByUserId(userId:String): List<NoteDto>{
        val user = userRepository.findById(UUID.fromString(userId)).orElseThrow { UserNotFound() }
        return user.notes.stream().map(NoteDto::fromNote).toList()
    }

    @CachePut(value = ["userNotes"], key = "'getNotesByUserId' + #userId")
    fun saveNoteContent(userId: String, title: String, noteId: String, content: String){
        val note = getNoteWithPermission(userId, noteId)
        note.title = title
        note.content = content
        noteRepository.save(note)
    }

    @CachePut(value = ["userNotes"], key = "'getNotesByUserId' + #userId")
    fun createNote(userId: String, title: String, content: String): String {
        val user = userRepository.findById(UUID.fromString(userId)).orElseThrow { UserNotFound() }
        return noteRepository.save(Note().apply {
            this.title = title
            this.content = content
            this.owner = user
        }).id.toString()
    }

    @CacheEvict(value = ["userNotes"], key = "'getNotesByUserId' + #userId")
    fun deleteNote(userId: String, noteId: String) {
        val note = getNoteWithPermission(userId, noteId)
        noteRepository.deleteById(note.id!!)
    }

    fun getNoteByNoteId(userId: String, noteId: String): NoteDto {
        val note = getNoteWithPermission(userId, noteId)
        return NoteDto.fromNote(note)
    }

    private fun getNoteWithPermission(userId: String, noteId: String): Note {
        val uuid = StringBuffer(noteId).apply {
            insert(8, '-')
            insert(13, '-')
            insert(18, '-')
            insert(23, '-')
        }.toString()
        val note = noteRepository.findById(UUID.fromString(uuid)).orElseThrow { NoteNotFound() }
        if (note.owner!!.id!! != UUID.fromString(userId))
            throw UnAuthorized()
        return note
    }
}