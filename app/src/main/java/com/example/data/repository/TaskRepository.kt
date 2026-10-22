package com.example.data.repository

import com.example.data.local.RoutineDao
import com.example.data.local.RoutineEntity
import com.example.data.local.TaskDao
import com.example.data.local.TaskEntity
import kotlinx.coroutines.flow.Flow

class TaskRepository(
    private val taskDao: TaskDao,
    private val routineDao: RoutineDao
) {
    val allTasks: Flow<List<TaskEntity>> = taskDao.getAllTasks()
    val allRoutines: Flow<List<RoutineEntity>> = routineDao.getAllRoutines()

    suspend fun insertTask(task: TaskEntity): Long {
        return taskDao.insertTask(task)
    }

    suspend fun insertTasks(tasks: List<TaskEntity>) {
        taskDao.insertAll(tasks)
    }

    suspend fun updateTask(task: TaskEntity) {
        taskDao.updateTask(task)
    }

    suspend fun deleteTask(task: TaskEntity) {
        taskDao.deleteTask(task)
    }

    suspend fun deleteTaskById(id: Int) {
        taskDao.deleteTaskById(id)
    }

    suspend fun deleteAllTasks() {
        taskDao.deleteAllTasks()
    }

    suspend fun deleteTasksByDate(dateString: String) {
        taskDao.deleteTasksByDate(dateString)
    }

    suspend fun insertRoutine(routine: RoutineEntity): Long {
        return routineDao.insertRoutine(routine)
    }

    suspend fun deleteRoutine(routine: RoutineEntity) {
        routineDao.deleteRoutine(routine)
    }

    suspend fun deleteRoutineById(id: Int) {
        routineDao.deleteRoutineById(id)
    }

    /**
     * Applies a routine to a specific date (e.g. "Today", "Tomorrow", "Mon, Apr 24")
     * If replaceExisting is true, clears any existing tasks for that day first.
     */
    suspend fun applyRoutineToDay(
        routine: RoutineEntity,
        targetDateString: String,
        replaceExisting: Boolean = true
    ) {
        if (replaceExisting) {
            taskDao.deleteTasksByDate(targetDateString)
        }
        val items = parseTasksData(routine.tasksData, targetDateString)
        if (items.isNotEmpty()) {
            taskDao.insertAll(items)
        }
    }

    fun getDatesForScope(scope: String): List<String> {
        return when (scope.lowercase()) {
            "today" -> listOf("Today")
            "tomorrow" -> listOf("Tomorrow")
            "week", "this week" -> listOf(
                "Today",
                "Tomorrow",
                "Mon, April 24",
                "Tue, April 25",
                "Wed, April 26",
                "Thu, April 27",
                "Fri, April 28",
                "Sat, April 29",
                "Sun, April 30"
            )
            "month", "this month" -> {
                val dates = mutableListOf("Today", "Tomorrow")
                val daysInMonth = listOf(
                    "Mon, April 24", "Tue, April 25", "Wed, April 26", "Thu, April 27", "Fri, April 28", "Sat, April 29", "Sun, April 30"
                )
                dates.addAll(daysInMonth)
                for (day in 1..30) {
                    dates.add("Day $day")
                }
                dates.distinct()
            }
            else -> listOf(scope)
        }
    }

    /**
     * Applies a list of tasks across a given scope (Today, Tomorrow, Week, Month)
     * Supports clearing old tasks if replaceExisting is true.
     */
    suspend fun applyTasksToScope(
        tasks: List<TaskEntity>,
        scope: String,
        replaceExisting: Boolean = true
    ) {
        val targetDates = getDatesForScope(scope)
        if (replaceExisting) {
            if (scope.equals("month", ignoreCase = true) || scope.equals("this month", ignoreCase = true)) {
                taskDao.deleteAllTasks()
            } else {
                for (date in targetDates) {
                    taskDao.deleteTasksByDate(date)
                }
            }
        }
        val toInsert = mutableListOf<TaskEntity>()
        for (date in targetDates) {
            for (task in tasks) {
                toInsert.add(
                    task.copy(
                        id = 0,
                        dateString = date
                    )
                )
            }
        }
        if (toInsert.isNotEmpty()) {
            taskDao.insertAll(toInsert)
        }
    }

    /**
     * Saves a list of tasks as a reusable Routine template
     */
    suspend fun saveTasksAsRoutine(
        name: String,
        description: String,
        category: String,
        tasks: List<TaskEntity>
    ): Long {
        val serialized = serializeTasks(tasks)
        val summary = "${tasks.size} activities • ${tasks.firstOrNull()?.startTime ?: ""} - ${tasks.lastOrNull()?.endTime ?: ""}"
        val routine = RoutineEntity(
            name = name,
            description = description,
            category = category,
            iconKey = when {
                name.contains("Football", ignoreCase = true) -> "sports"
                name.contains("Weekend", ignoreCase = true) -> "weekend"
                else -> "schedule"
            },
            itemsSummary = summary,
            tasksData = serialized
        )
        return routineDao.insertRoutine(routine)
    }

    suspend fun initializeDefaultDataIfEmpty() {
        if (taskDao.getCount() == 0) {
            resetAllToUserRoutineSchedule()
        }
        if (routineDao.getCount() == 0) {
            initializeDefaultRoutines()
        }
    }

    /**
     * Clears all old tasks and inserts This Week's requested routine schedule
     */
    suspend fun resetAllToUserRoutineSchedule() {
        resetAllToThisWeekRoutineSchedule()
    }

    suspend fun resetAllToThisWeekRoutineSchedule() {
        taskDao.deleteAllTasks()

        val todayTasks = createThisWeekTimelineTasks("Today")
        val tomorrowTasks = createThisWeekDeepWorkTimelineTasks("Tomorrow")
        val wednesdayTasks = listOf(
            TaskEntity(
                title = "Mid-Week Milestone Review",
                description = "Evaluate sprint progress, unblock technical issues & update task board.",
                dateString = "Wed, Oct 8",
                startTime = "10:00 AM",
                endTime = "11:30 AM",
                priority = "High",
                status = "To Do",
                project = "Sprint Tracking",
                tags = "Review,Sprint,Planning",
                timeSection = "Morning",
                colorTheme = "peach",
                isCompleted = false
            ),
            TaskEntity(
                title = "Client & Stakeholder Demo",
                description = "Present interactive prototype and collect milestone validation.",
                dateString = "Wed, Oct 8",
                startTime = "02:00 PM",
                endTime = "03:15 PM",
                priority = "Urgent",
                status = "To Do",
                project = "Stakeholder Sync",
                tags = "Demo,Meeting",
                timeSection = "Afternoon",
                colorTheme = "blue",
                hasMeeting = true,
                isCompleted = false
            )
        )
        val thursdayTasks = listOf(
            TaskEntity(
                title = "Architecture Refactoring & Polish",
                description = "Optimize state management and refine responsive UI layouts.",
                dateString = "Thu, Oct 9",
                startTime = "09:30 AM",
                endTime = "12:30 PM",
                priority = "High",
                status = "To Do",
                project = "Core Architecture",
                tags = "Code,Refactor",
                timeSection = "Morning",
                colorTheme = "lavender",
                isCompleted = false
            )
        )
        val fridayTasks = listOf(
            TaskEntity(
                title = "Weekly Release & QA Signoff",
                description = "Final testing run, generate build artifacts, ship milestone release.",
                dateString = "Fri, Oct 10",
                startTime = "03:00 PM",
                endTime = "05:00 PM",
                priority = "Urgent",
                status = "To Do",
                project = "Ship & Release",
                tags = "Release,QA,Ship",
                timeSection = "Afternoon",
                colorTheme = "red",
                isCompleted = false
            )
        )

        taskDao.insertAll(todayTasks + tomorrowTasks + wednesdayTasks + thursdayTasks + fridayTasks)
    }

    private suspend fun initializeDefaultRoutines() {
        resetAllRoutinesToThisWeek()
    }

    suspend fun resetAllRoutinesToThisWeek() {
        routineDao.deleteAllRoutines()

        val thisWeekMasterTasks = createThisWeekTimelineTasks("Template")
        val thisWeekDeepWorkTasks = createThisWeekDeepWorkTimelineTasks("Template")
        val thisWeekWellnessTasks = createThisWeekWellnessTimelineTasks("Template")

        val routines = listOf(
            RoutineEntity(
                name = "This Week Routine",
                description = "Complete weekly schedule: Monday to Sunday focus roadmap, deep work sprints, collaborative review & daily milestones.",
                category = "This Week",
                iconKey = "schedule",
                itemsSummary = "7 Days • Weekly Focus Rhythm",
                tasksData = serializeTasks(thisWeekMasterTasks)
            ),
            RoutineEntity(
                name = "This Week Deep Work Sprint",
                description = "High-velocity weekly execution sprint focused on unblocking key deliverables and feature polish.",
                category = "This Week / Sprint",
                iconKey = "work",
                itemsSummary = "6 Focused Tasks • 08:00 AM - 07:15 PM",
                tasksData = serializeTasks(thisWeekDeepWorkTasks)
            ),
            RoutineEntity(
                name = "This Week Balanced & Wellness",
                description = "Balanced weekly rhythm for sustained performance, workouts, reading and recovery.",
                category = "This Week / Wellness",
                iconKey = "health",
                itemsSummary = "5 Milestones • 08:00 AM - 10:30 PM",
                tasksData = serializeTasks(thisWeekWellnessTasks)
            )
        )
        routineDao.insertAll(routines)
    }

    fun createStandardTimelineTasks(dateString: String): List<TaskEntity> {
        return listOf(
            TaskEntity(
                title = "Wake Up & Morning Prep",
                description = "Wake up at 7:00 AM, morning wash, fresh hydration & prepare for the day.",
                dateString = dateString,
                startTime = "07:00 AM",
                endTime = "07:45 AM",
                priority = "Medium",
                status = "To Do",
                project = "Morning Routine",
                tags = "Morning,Routine,WakeUp",
                timeSection = "Morning",
                colorTheme = "peach",
                isCompleted = false,
                isFreeTime = false
            ),
            TaskEntity(
                title = "School & Classes",
                description = "School from 8:00 AM to 12:00 PM. Focus on lectures, coursework & discussions.",
                dateString = dateString,
                startTime = "08:00 AM",
                endTime = "12:00 PM",
                priority = "High",
                status = "To Do",
                project = "Education & School",
                tags = "School,Class,Academics",
                timeSection = "Morning",
                colorTheme = "blue",
                isCompleted = false,
                isFreeTime = false
            ),
            TaskEntity(
                title = "Back Home & Lunch",
                description = "Arrive home from school, eat a nutritious lunch & recharge.",
                dateString = dateString,
                startTime = "12:00 PM",
                endTime = "12:45 PM",
                priority = "Medium",
                status = "To Do",
                project = "Daily Routine",
                tags = "Lunch,Home,Food",
                timeSection = "Afternoon",
                colorTheme = "mint",
                isCompleted = false,
                isFreeTime = false
            ),
            TaskEntity(
                title = "Power Nap / Sleep (45 min)",
                description = "45-minute power nap to rest brain and recover physical energy.",
                dateString = dateString,
                startTime = "12:45 PM",
                endTime = "01:30 PM",
                priority = "Medium",
                status = "To Do",
                project = "Rest & Wellness",
                tags = "Sleep,Nap,Rest",
                timeSection = "Afternoon",
                colorTheme = "lavender",
                isCompleted = false,
                isFreeTime = false
            ),
            TaskEntity(
                title = "Free Time & Relaxation",
                description = "Open personal free time — unwind, relax, play or browse. No checklist needed.",
                dateString = dateString,
                startTime = "01:30 PM",
                endTime = "02:30 PM",
                priority = "Low",
                status = "To Do",
                project = "Personal Time",
                tags = "FreeTime,Relax,Break",
                timeSection = "Afternoon",
                colorTheme = "yellow",
                isCompleted = false,
                isFreeTime = true
            ),
            TaskEntity(
                title = "Gym Session (1 Hour)",
                description = "Go to the gym for 1 Hour: weight lifting, strength training & cardio.",
                dateString = dateString,
                startTime = "02:30 PM",
                endTime = "03:30 PM",
                priority = "High",
                status = "To Do",
                project = "Health & Fitness",
                tags = "Gym,Fitness,Workout",
                timeSection = "Afternoon",
                colorTheme = "red",
                isCompleted = false,
                isFreeTime = false
            ),
            TaskEntity(
                title = "Coffee Break (30 min)",
                description = "Enjoy a warm coffee for 30 minutes, protein snack & calm breather.",
                dateString = dateString,
                startTime = "03:30 PM",
                endTime = "04:00 PM",
                priority = "Low",
                status = "To Do",
                project = "Break & Wellness",
                tags = "Coffee,Break,Relax",
                timeSection = "Afternoon",
                colorTheme = "peach",
                isCompleted = false,
                isFreeTime = false
            ),
            TaskEntity(
                title = "Study & Revision (1:30)",
                description = "1 Hour 30 min revision: solve exercises, review school lessons & practice notes.",
                dateString = dateString,
                startTime = "04:00 PM",
                endTime = "05:30 PM",
                priority = "High",
                status = "To Do",
                project = "Study & Academics",
                tags = "Study,Revision,School",
                timeSection = "Afternoon",
                colorTheme = "blue",
                isCompleted = false,
                isFreeTime = false
            ),
            TaskEntity(
                title = "Reading a Book (30 min)",
                description = "Read 30 minutes of personal development book or novel before evening.",
                dateString = dateString,
                startTime = "05:30 PM",
                endTime = "06:00 PM",
                priority = "Medium",
                status = "To Do",
                project = "Self Growth",
                tags = "Reading,Book,Focus",
                timeSection = "Evening",
                colorTheme = "lavender",
                isCompleted = false,
                isFreeTime = false
            ),
            TaskEntity(
                title = "Football Match & Sports",
                description = "Football match on field with friends: teamwork, running & sports fun.",
                dateString = dateString,
                startTime = "06:00 PM",
                endTime = "07:30 PM",
                priority = "Medium",
                status = "To Do",
                project = "Sports & Football",
                tags = "Football,Sports,Match",
                timeSection = "Evening",
                colorTheme = "mint",
                isCompleted = false,
                isFreeTime = false
            ),
            TaskEntity(
                title = "Evening Free Time & Dinner",
                description = "Family dinner, casual leisure time & evening entertainment at your own pace.",
                dateString = dateString,
                startTime = "07:30 PM",
                endTime = "10:30 PM",
                priority = "Low",
                status = "To Do",
                project = "Personal Time",
                tags = "FreeTime,Dinner,Family",
                timeSection = "Evening",
                colorTheme = "yellow",
                isCompleted = false,
                isFreeTime = true
            ),
            TaskEntity(
                title = "Go to Sleep & Bedtime",
                description = "Turn off phone screens, relax & sleep for 8 hours of deep restorative rest.",
                dateString = dateString,
                startTime = "10:30 PM",
                endTime = "11:00 PM",
                priority = "High",
                status = "To Do",
                project = "Rest & Sleep",
                tags = "Sleep,Bedtime,Health",
                timeSection = "Evening",
                colorTheme = "lavender",
                isCompleted = false,
                isFreeTime = false
            )
        )
    }

    fun createMorningFootballTimelineTasks(dateString: String): List<TaskEntity> {
        return listOf(
            TaskEntity(
                title = "Early Wakeup & Gear Up",
                description = "Wake up at 06:30 AM, drink electrolytes, put on football boots and kit.",
                dateString = dateString,
                startTime = "06:30 AM",
                endTime = "07:00 AM",
                priority = "High",
                status = "To Do",
                project = "Sports & Football",
                tags = "WakeUp,Football,Morning",
                timeSection = "Morning",
                colorTheme = "peach",
                isCompleted = false,
                isFreeTime = false
            ),
            TaskEntity(
                title = "Morning Football Match ⚽",
                description = "Full 60-min competitive morning football match and drills on pitch.",
                dateString = dateString,
                startTime = "07:00 AM",
                endTime = "08:00 AM",
                priority = "High",
                status = "To Do",
                project = "Sports & Football",
                tags = "Football,Match,Cardio",
                timeSection = "Morning",
                colorTheme = "mint",
                isCompleted = false,
                isFreeTime = false
            ),
            TaskEntity(
                title = "School & Classes",
                description = "School from 8:00 AM to 12:00 PM with teammates and classmates.",
                dateString = dateString,
                startTime = "08:00 AM",
                endTime = "12:00 PM",
                priority = "High",
                status = "To Do",
                project = "Education & School",
                tags = "School,Class,Academics",
                timeSection = "Morning",
                colorTheme = "blue",
                isCompleted = false,
                isFreeTime = false
            ),
            TaskEntity(
                title = "Back Home & Big Lunch",
                description = "Post-football high protein recovery meal & shower.",
                dateString = dateString,
                startTime = "12:00 PM",
                endTime = "12:45 PM",
                priority = "Medium",
                status = "To Do",
                project = "Daily Routine",
                tags = "Lunch,Recovery",
                timeSection = "Afternoon",
                colorTheme = "peach",
                isCompleted = false,
                isFreeTime = false
            ),
            TaskEntity(
                title = "Power Nap / Sleep (45 min)",
                description = "45-minute muscle recovery sleep.",
                dateString = dateString,
                startTime = "12:45 PM",
                endTime = "01:30 PM",
                priority = "Medium",
                status = "To Do",
                project = "Rest & Wellness",
                tags = "Sleep,Recovery",
                timeSection = "Afternoon",
                colorTheme = "lavender",
                isCompleted = false,
                isFreeTime = false
            ),
            TaskEntity(
                title = "Free Time & Relaxation",
                description = "Free personal downtime to game, chill or listen to music.",
                dateString = dateString,
                startTime = "01:30 PM",
                endTime = "02:30 PM",
                priority = "Low",
                status = "To Do",
                project = "Personal Time",
                tags = "FreeTime,Relax",
                timeSection = "Afternoon",
                colorTheme = "yellow",
                isCompleted = false,
                isFreeTime = true
            ),
            TaskEntity(
                title = "Gym Session (1 Hour)",
                description = "Upper body strength and mobility workout.",
                dateString = dateString,
                startTime = "02:30 PM",
                endTime = "03:30 PM",
                priority = "High",
                status = "To Do",
                project = "Health & Fitness",
                tags = "Gym,Strength",
                timeSection = "Afternoon",
                colorTheme = "red",
                isCompleted = false,
                isFreeTime = false
            ),
            TaskEntity(
                title = "Coffee Break (30 min)",
                description = "Coffee and protein snack with friends.",
                dateString = dateString,
                startTime = "03:30 PM",
                endTime = "04:00 PM",
                priority = "Low",
                status = "To Do",
                project = "Break & Wellness",
                tags = "Coffee,Break",
                timeSection = "Afternoon",
                colorTheme = "peach",
                isCompleted = false,
                isFreeTime = false
            ),
            TaskEntity(
                title = "Study & Revision (1:30)",
                description = "Review lesson chapters and homework.",
                dateString = dateString,
                startTime = "04:00 PM",
                endTime = "05:30 PM",
                priority = "High",
                status = "To Do",
                project = "Study & Academics",
                tags = "Study,Revision",
                timeSection = "Afternoon",
                colorTheme = "blue",
                isCompleted = false,
                isFreeTime = false
            ),
            TaskEntity(
                title = "Reading a Book (30 min)",
                description = "Book reading session.",
                dateString = dateString,
                startTime = "05:30 PM",
                endTime = "06:00 PM",
                priority = "Medium",
                status = "To Do",
                project = "Self Growth",
                tags = "Reading,Book",
                timeSection = "Evening",
                colorTheme = "lavender",
                isCompleted = false,
                isFreeTime = false
            ),
            TaskEntity(
                title = "Evening Free Time",
                description = "Relaxed evening, dinner and highlights.",
                dateString = dateString,
                startTime = "06:00 PM",
                endTime = "10:30 PM",
                priority = "Low",
                status = "To Do",
                project = "Personal Time",
                tags = "FreeTime,Relax",
                timeSection = "Evening",
                colorTheme = "yellow",
                isCompleted = false,
                isFreeTime = true
            ),
            TaskEntity(
                title = "Go to Sleep",
                description = "Early sleep for tomorrow's recovery.",
                dateString = dateString,
                startTime = "10:30 PM",
                endTime = "11:00 PM",
                priority = "High",
                status = "To Do",
                project = "Rest & Sleep",
                tags = "Sleep,Bedtime",
                timeSection = "Evening",
                colorTheme = "lavender",
                isCompleted = false,
                isFreeTime = false
            )
        )
    }

    fun createWeekendTimelineTasks(dateString: String): List<TaskEntity> {
        return listOf(
            TaskEntity(
                title = "Weekend Wake Up & Breakfast",
                description = "Restful weekend morning wakeup, big breakfast & morning coffee.",
                dateString = dateString,
                startTime = "08:30 AM",
                endTime = "09:30 AM",
                priority = "Medium",
                status = "To Do",
                project = "Weekend Routine",
                tags = "Weekend,Breakfast",
                timeSection = "Morning",
                colorTheme = "peach",
                isCompleted = false,
                isFreeTime = false
            ),
            TaskEntity(
                title = "Morning Gym & Conditioning",
                description = "Full gym strength session, core & mobility workout.",
                dateString = dateString,
                startTime = "10:00 AM",
                endTime = "11:30 AM",
                priority = "High",
                status = "To Do",
                project = "Health & Fitness",
                tags = "Gym,Fitness",
                timeSection = "Morning",
                colorTheme = "red",
                isCompleted = false,
                isFreeTime = false
            ),
            TaskEntity(
                title = "Lunch & Free Time",
                description = "Lunch and personal free time to unwind.",
                dateString = dateString,
                startTime = "12:00 PM",
                endTime = "02:00 PM",
                priority = "Low",
                status = "To Do",
                project = "Personal Time",
                tags = "FreeTime,Lunch",
                timeSection = "Afternoon",
                colorTheme = "yellow",
                isCompleted = false,
                isFreeTime = true
            ),
            TaskEntity(
                title = "Study & Exam Revision",
                description = "Focused weekend revision & summary notes.",
                dateString = dateString,
                startTime = "02:00 PM",
                endTime = "03:30 PM",
                priority = "High",
                status = "To Do",
                project = "Study & Academics",
                tags = "Study,Revision",
                timeSection = "Afternoon",
                colorTheme = "blue",
                isCompleted = false,
                isFreeTime = false
            ),
            TaskEntity(
                title = "Reading a Book (30m)",
                description = "30-min book reading.",
                dateString = dateString,
                startTime = "03:30 PM",
                endTime = "04:00 PM",
                priority = "Medium",
                status = "To Do",
                project = "Self Growth",
                tags = "Reading,Book",
                timeSection = "Afternoon",
                colorTheme = "lavender",
                isCompleted = false,
                isFreeTime = false
            ),
            TaskEntity(
                title = "Weekend Football Match ⚽",
                description = "Weekend league / friendly football match with squad.",
                dateString = dateString,
                startTime = "04:30 PM",
                endTime = "06:30 PM",
                priority = "High",
                status = "To Do",
                project = "Sports & Football",
                tags = "Football,Match,Sports",
                timeSection = "Evening",
                colorTheme = "mint",
                isCompleted = false,
                isFreeTime = false
            ),
            TaskEntity(
                title = "Dinner & Celebration",
                description = "Post-match dinner with friends & family.",
                dateString = dateString,
                startTime = "07:00 PM",
                endTime = "08:30 PM",
                priority = "Medium",
                status = "To Do",
                project = "Personal Time",
                tags = "Dinner,Social",
                timeSection = "Evening",
                colorTheme = "peach",
                isCompleted = false,
                isFreeTime = false
            ),
            TaskEntity(
                title = "Night Free Time & Entertainment",
                description = "Watch match highlights, movies or game freely.",
                dateString = dateString,
                startTime = "08:30 PM",
                endTime = "11:00 PM",
                priority = "Low",
                status = "To Do",
                project = "Personal Time",
                tags = "FreeTime,Movies",
                timeSection = "Evening",
                colorTheme = "yellow",
                isCompleted = false,
                isFreeTime = true
            ),
            TaskEntity(
                title = "Sleep & Rest",
                description = "Restful sleep.",
                dateString = dateString,
                startTime = "11:00 PM",
                endTime = "11:30 PM",
                priority = "Medium",
                status = "To Do",
                project = "Rest & Sleep",
                tags = "Sleep",
                timeSection = "Evening",
                colorTheme = "lavender",
                isCompleted = false,
                isFreeTime = false
            )
        )
    }

    private fun serializeTasks(tasks: List<TaskEntity>): String {
        return tasks.joinToString(";;") { task ->
            listOf(
                task.title,
                task.startTime,
                task.endTime,
                task.timeSection,
                task.priority,
                task.colorTheme,
                task.project,
                task.tags,
                task.description,
                if (task.isFreeTime) "1" else "0"
            ).joinToString("||")
        }
    }

    fun parseTasksData(data: String, targetDateString: String): List<TaskEntity> {
        if (data.isBlank()) return emptyList()
        val blocks = data.split(";;").filter { it.isNotBlank() }
        return blocks.mapNotNull { block ->
            val parts = block.split("||")
            if (parts.size >= 9) {
                TaskEntity(
                    title = parts[0],
                    startTime = parts[1],
                    endTime = parts[2],
                    timeSection = parts[3],
                    priority = parts[4],
                    colorTheme = parts[5],
                    project = parts[6],
                    tags = parts[7],
                    description = parts[8],
                    isFreeTime = parts.getOrNull(9) == "1",
                    dateString = targetDateString,
                    status = "To Do",
                    isCompleted = false
                )
            } else null
        }
    }

    fun createThisWeekTimelineTasks(dateString: String): List<TaskEntity> {
        return listOf(
            TaskEntity(
                title = "Weekly Kickoff & Priority Alignment",
                description = "Review sprint goals, outline key milestones, and set focus priorities for this week.",
                dateString = dateString,
                startTime = "08:00 AM",
                endTime = "08:45 AM",
                priority = "High",
                status = "To Do",
                project = "Weekly Planning",
                tags = "Planning,Sprint,Goals",
                timeSection = "Morning",
                colorTheme = "peach",
                isCompleted = false
            ),
            TaskEntity(
                title = "Deep Work Block: Core Deliverables",
                description = "Dedicated 3-hour uninterrupted focus block for the top project milestones.",
                dateString = dateString,
                startTime = "09:00 AM",
                endTime = "12:00 PM",
                priority = "Urgent",
                status = "In Progress",
                project = "Product Development",
                tags = "DeepWork,Build,Focus",
                timeSection = "Morning",
                colorTheme = "blue",
                isCompleted = false
            ),
            TaskEntity(
                title = "Lunch & Mindful Recovery Break",
                description = "Healthy lunch, hydration, and mental reset away from screens.",
                dateString = dateString,
                startTime = "12:00 PM",
                endTime = "01:00 PM",
                priority = "Low",
                status = "To Do",
                project = "Wellness & Health",
                tags = "Lunch,Recovery,Break",
                timeSection = "Afternoon",
                colorTheme = "mint",
                isCompleted = false,
                isFreeTime = true
            ),
            TaskEntity(
                title = "Collaborative Review & Sync",
                description = "Align with collaborators, review feedback, unblock tasks and coordinate.",
                dateString = dateString,
                startTime = "01:15 PM",
                endTime = "02:30 PM",
                priority = "Medium",
                status = "To Do",
                project = "Team Collaboration",
                tags = "Sync,Review,Meeting",
                timeSection = "Afternoon",
                colorTheme = "lavender",
                hasMeeting = true,
                isCompleted = false
            ),
            TaskEntity(
                title = "Execution Sprint: Feature Polish & QA",
                description = "Implement requested features, polish UI details, verify test suites.",
                dateString = dateString,
                startTime = "02:45 PM",
                endTime = "05:00 PM",
                priority = "High",
                status = "To Do",
                project = "Feature Polish",
                tags = "QA,Build,Testing",
                timeSection = "Afternoon",
                colorTheme = "peach",
                isCompleted = false
            ),
            TaskEntity(
                title = "Fitness & Health Movement",
                description = "Gym workout, cardiovascular circuit, and mobility stretching.",
                dateString = dateString,
                startTime = "05:15 PM",
                endTime = "06:15 PM",
                priority = "High",
                status = "To Do",
                project = "Fitness & Energy",
                tags = "Gym,Health,Workout",
                timeSection = "Evening",
                colorTheme = "red",
                isCompleted = false
            ),
            TaskEntity(
                title = "Daily Wrap-up & Tomorrow Preparation",
                description = "Log completed achievements, clear inbox, and prepare schedule for tomorrow.",
                dateString = dateString,
                startTime = "06:30 PM",
                endTime = "07:15 PM",
                priority = "Medium",
                status = "To Do",
                project = "Daily Review",
                tags = "WrapUp,Tomorrow,Review",
                timeSection = "Evening",
                colorTheme = "blue",
                isCompleted = false
            ),
            TaskEntity(
                title = "Evening Relaxation & Sleep",
                description = "Dinner, reading, relaxation, and restorative sleep.",
                dateString = dateString,
                startTime = "08:00 PM",
                endTime = "10:30 PM",
                priority = "Low",
                status = "To Do",
                project = "Rest & Sleep",
                tags = "Rest,Sleep,Reading",
                timeSection = "Evening",
                colorTheme = "lavender",
                isCompleted = false,
                isFreeTime = true
            )
        )
    }

    fun createThisWeekDeepWorkTimelineTasks(dateString: String): List<TaskEntity> {
        return listOf(
            TaskEntity(
                title = "Morning Coffee & Agenda Sync",
                description = "Organize priority list, review bug reports, prepare deep focus session.",
                dateString = dateString,
                startTime = "08:30 AM",
                endTime = "09:00 AM",
                priority = "Medium",
                status = "To Do",
                project = "Daily Focus",
                tags = "Coffee,Agenda",
                timeSection = "Morning",
                colorTheme = "peach"
            ),
            TaskEntity(
                title = "Deep Coding & Architecture Sprint",
                description = "Intensive coding session on core backend and Android Jetpack Compose UI.",
                dateString = dateString,
                startTime = "09:15 AM",
                endTime = "12:30 PM",
                priority = "Urgent",
                status = "In Progress",
                project = "Codebase",
                tags = "Coding,DeepWork,Sprint",
                timeSection = "Morning",
                colorTheme = "blue"
            ),
            TaskEntity(
                title = "Power Lunch & Walk",
                description = "Nutritious meal and outdoor walk for cognitive recovery.",
                dateString = dateString,
                startTime = "12:30 PM",
                endTime = "01:30 PM",
                priority = "Low",
                status = "To Do",
                project = "Health",
                tags = "Lunch,Walk",
                timeSection = "Afternoon",
                colorTheme = "mint",
                isFreeTime = true
            ),
            TaskEntity(
                title = "Code Review & Technical Documentation",
                description = "Review PRs, document components, update architectural notes.",
                dateString = dateString,
                startTime = "01:45 PM",
                endTime = "03:45 PM",
                priority = "High",
                status = "To Do",
                project = "Engineering",
                tags = "CodeReview,Docs",
                timeSection = "Afternoon",
                colorTheme = "lavender"
            ),
            TaskEntity(
                title = "End-to-End Testing & Bug Fixes",
                description = "Verify edge cases, fix layout bugs, and ensure 100% build health.",
                dateString = dateString,
                startTime = "04:00 PM",
                endTime = "06:00 PM",
                priority = "High",
                status = "To Do",
                project = "Quality",
                tags = "Testing,BugFix",
                timeSection = "Afternoon",
                colorTheme = "peach"
            ),
            TaskEntity(
                title = "Release Wrap & Commit Log",
                description = "Stage release notes, write daily summary, and prepare tomorrow's kickoff.",
                dateString = dateString,
                startTime = "06:15 PM",
                endTime = "07:15 PM",
                priority = "Medium",
                status = "To Do",
                project = "Release",
                tags = "Release,Git",
                timeSection = "Evening",
                colorTheme = "mint"
            )
        )
    }

    fun createThisWeekWellnessTimelineTasks(dateString: String): List<TaskEntity> {
        return listOf(
            TaskEntity(
                title = "Morning Mindfulness & Workout",
                description = "Morning hydration, stretching, and physical training.",
                dateString = dateString,
                startTime = "08:00 AM",
                endTime = "09:30 AM",
                priority = "High",
                status = "To Do",
                project = "Wellness Routine",
                tags = "Health,Workout,Mindset",
                timeSection = "Morning",
                colorTheme = "mint"
            ),
            TaskEntity(
                title = "Learning & Reading Block",
                description = "Reading books, tech articles, and creative brainstorming.",
                dateString = dateString,
                startTime = "10:00 AM",
                endTime = "12:00 PM",
                priority = "Medium",
                status = "To Do",
                project = "Self Growth",
                tags = "Reading,Study,Learning",
                timeSection = "Morning",
                colorTheme = "blue"
            ),
            TaskEntity(
                title = "Mid-Day Rest & Outdoor Walk",
                description = "Lunch, outdoor walk and fresh air recharge.",
                dateString = dateString,
                startTime = "12:30 PM",
                endTime = "02:00 PM",
                priority = "Low",
                status = "To Do",
                project = "Rest & Recovery",
                tags = "Walk,Nature,Relax",
                timeSection = "Afternoon",
                colorTheme = "yellow",
                isFreeTime = true
            ),
            TaskEntity(
                title = "Creative Projects & Hobby Sprint",
                description = "Work on personal side projects, design exploration, or passion builds.",
                dateString = dateString,
                startTime = "02:30 PM",
                endTime = "05:00 PM",
                priority = "High",
                status = "To Do",
                project = "Creative Sprint",
                tags = "Projects,Build,Design",
                timeSection = "Afternoon",
                colorTheme = "peach"
            ),
            TaskEntity(
                title = "Social Evening & Restorative Sleep",
                description = "Dinner with friends/family, relaxing entertainment, and sleep.",
                dateString = dateString,
                startTime = "07:00 PM",
                endTime = "10:30 PM",
                priority = "Low",
                status = "To Do",
                project = "Personal Time",
                tags = "Social,Rest,Sleep",
                timeSection = "Evening",
                colorTheme = "lavender",
                isFreeTime = true
            )
        )
    }
}
