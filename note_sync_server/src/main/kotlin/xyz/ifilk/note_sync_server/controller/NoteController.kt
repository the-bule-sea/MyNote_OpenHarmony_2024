package xyz.ifilk.note_sync_server.controller

import cn.dev33.satoken.stp.StpUtil
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.Parameter
import io.swagger.v3.oas.annotations.enums.ParameterIn
import jakarta.validation.Valid
import org.springframework.web.bind.annotation.*
import xyz.ifilk.note_sync_server.model.NoteApplyDto
import xyz.ifilk.note_sync_server.model.NoteDto
import xyz.ifilk.note_sync_server.service.NoteServiceImpl

@RestController
@CrossOrigin
class NoteController(private val noteServiceImpl: NoteServiceImpl) {

    @GetMapping("/notes")
    @Operation(summary = "获取用户的全部笔记")
    @Parameter(name = "www-authorization", description = "token", `in` = ParameterIn.HEADER)
    fun getNotes(): List<NoteDto> {
        val userId = StpUtil.getLoginIdAsString()
        return noteServiceImpl.getNotesByUserId(userId!!)
    }

    @PutMapping("/notes/{noteId}")
    @Operation(summary = "编辑笔记")
    @Parameter(name = "noteId", description = "笔记Id", `in` = ParameterIn.PATH)
    @Parameter(name = "title", description = "笔记标题", `in` = ParameterIn.QUERY)
    @Parameter(name = "content", description = "笔记正文", `in` = ParameterIn.QUERY)
    @Parameter(name = "www-authorization", description = "token", `in` = ParameterIn.HEADER)
    fun updateNote(@PathVariable noteId: String, @Valid @RequestBody noteApplyDto: NoteApplyDto): String {
        val userId = StpUtil.getLoginIdAsString()
        noteServiceImpl.saveNoteContent(userId, noteApplyDto.title!!, noteId, noteApplyDto.content!!)
        return "ok"
    }

    @PostMapping("/notes")
    @Operation(summary = "创建笔记")
    @Parameter(name = "title", description = "笔记标题", `in` = ParameterIn.QUERY)
    @Parameter(name = "content", description = "笔记正文", `in` = ParameterIn.QUERY)
    @Parameter(name = "www-authorization", description = "token", `in` = ParameterIn.HEADER)
    fun createNote(@Valid @RequestBody noteApplyDto: NoteApplyDto): String {
        val userId = StpUtil.getLoginIdAsString()
        return noteServiceImpl.createNote(userId, noteApplyDto.title!!, noteApplyDto.content!!)
    }

    @GetMapping("/notes/{noteId}")
    @Operation(summary = "获取笔记")
    @Parameter(name = "noteId", description = "笔记Id", `in` = ParameterIn.PATH)
    @Parameter(name = "www-authorization", description = "token", `in` = ParameterIn.HEADER)
    fun getNote(@PathVariable noteId: String): NoteDto {
        val userId = StpUtil.getLoginIdAsString()
        return noteServiceImpl.getNoteByNoteId(userId, noteId)
    }

    @DeleteMapping("/notes/{noteId}")
    @Operation(summary = "删除笔记")
    @Parameter(name = "noteId", description = "笔记Id", `in` = ParameterIn.PATH)
    @Parameter(name = "www-authorization", description = "token", `in` = ParameterIn.HEADER)
    fun deleteNote(@PathVariable noteId: String): String {
        val userId = StpUtil.getLoginIdAsString()
        noteServiceImpl.deleteNote(userId, noteId)
        return "ok"
    }
}