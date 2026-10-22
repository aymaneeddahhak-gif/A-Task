package com.example.data.local

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "routines")
data class RoutineEntity(
    @PrimaryKey(autoGenerate = true)
    val id: Int = 0,
    val name: String,
    val description: String = "",
    val category: String = "Daily", // "Daily", "School", "Weekend", "Sports"
    val iconKey: String = "schedule",
    val itemsSummary: String = "", // e.g. "12 Activities • 07:00 AM - 10:30 PM"
    val tasksData: String = "", // JSON or formatted list of routine activities
    val createdAt: Long = System.currentTimeMillis()
)
