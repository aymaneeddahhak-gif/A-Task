package com.example.data.local

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "tasks")
data class TaskEntity(
    @PrimaryKey(autoGenerate = true)
    val id: Int = 0,
    val title: String,
    val description: String = "",
    val dateString: String = "Today", // e.g. "Wed, Apr 26", "2026-08-14"
    val startTime: String = "10:00 AM",
    val endTime: String = "11:00 AM",
    val priority: String = "Medium", // "High", "Medium", "Low"
    val status: String = "To Do", // "To Do", "In Progress", "In Review", "Done"
    val project: String = "Website Redesign",
    val tags: String = "Design,Work", // comma-separated
    val hasMeeting: Boolean = false,
    val meetTitle: String = "Meet",
    val isStarred: Boolean = false,
    val assigneeCount: Int = 4,
    val timeSection: String = "Morning", // "Morning", "Afternoon", "Evening"
    val createdAt: Long = System.currentTimeMillis(),
    val isCompleted: Boolean = false,
    val colorTheme: String = "blue", // "blue", "peach", "lavender", "mint", "yellow", "pink"
    val isFreeTime: Boolean = false
) {
    fun getTagList(): List<String> {
        if (tags.isBlank()) return emptyList()
        return tags.split(",").map { it.trim() }.filter { it.isNotEmpty() }
    }
}
