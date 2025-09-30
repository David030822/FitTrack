using dotnet.DAL;
using dotnet.Repositories;

namespace dotnet.Services
{
    public class WorkoutScheduleService : IWorkoutScheduleService
    {
        private readonly IWorkoutScheduleRepository _scheduleRepo;
        private readonly IWorkoutScheduleDayRepository _dayRepo;
        private readonly IPlannedWorkoutRepository _workoutRepo;

        public WorkoutScheduleService(
            IWorkoutScheduleRepository scheduleRepo,
            IWorkoutScheduleDayRepository dayRepo,
            IPlannedWorkoutRepository workoutRepo)
        {
            _scheduleRepo = scheduleRepo;
            _dayRepo = dayRepo;
            _workoutRepo = workoutRepo;
        }

        public async Task<List<WorkoutScheduleDAL>> GetSchedulesForUserAsync(int userId)
            => await _scheduleRepo.GetSchedulesForUserAsync(userId);

        public async Task<WorkoutScheduleDAL> GetScheduleByIdAsync(int id)
            => await _scheduleRepo.GetScheduleByIdAsync(id);

        public async Task<WorkoutScheduleDAL> CreateScheduleAsync(int userId, string title)
        {
            var schedule = new WorkoutScheduleDAL
            {
                UserID = userId,
                Title = title,
                CreatedAt = DateTime.UtcNow,
                IsActive = false,
                Days = Enumerable.Range(0, 7).Select(i => new WorkoutScheduleDayDAL
                {
                    DayOfWeek = i,
                    IsRestDay = false,
                    StartTime = new TimeOnly(8, 0),
                    WorkoutLabel = ""
                }).ToList()
            };
            return await _scheduleRepo.CreateScheduleAsync(schedule);
        }

        public async Task UpdateScheduleTitleAsync(int id, string newTitle)
        {
            var schedule = await _scheduleRepo.GetScheduleByIdAsync(id);
            if (schedule == null) throw new Exception("Schedule not found");
            schedule.Title = newTitle;
            await _scheduleRepo.SaveChangesAsync();
        }

        public async Task DeleteScheduleAsync(int id)
            => await _scheduleRepo.DeleteScheduleAsync(id);

        public async Task ToggleActiveScheduleAsync(int scheduleId)
        {
            await _scheduleRepo.ToggleActiveScheduleAsync(scheduleId);
        }

        public async Task<List<PlannedWorkoutDAL>> GetWorkoutsForDayAsync(int dayId)
            => await _workoutRepo.GetWorkoutsForDayAsync(dayId);

        public async Task<WorkoutScheduleDayDAL> GetDayAsync(int dayId)
            => await _dayRepo.GetDayAsync(dayId);

        public async Task ToggleRestDayAsync(int dayId)
        {
            var day = await _dayRepo.GetDayAsync(dayId);
            day.IsRestDay = !day.IsRestDay;
            await _dayRepo.SaveChangesAsync();
        }

        public async Task UpdateDayAsync(int dayId, string? workoutLabel, TimeOnly? startTime)
        {
            var day = await _dayRepo.GetDayAsync(dayId);
            if (day == null)
                throw new Exception("Day not found");

            if (!string.IsNullOrEmpty(workoutLabel))
                day.WorkoutLabel = workoutLabel;

            if (startTime.HasValue)
                day.StartTime = startTime.Value;

            await _dayRepo.UpdateDayAsync(day);
        }

        public async Task<PlannedWorkoutDAL> AddWorkoutToDayAsync(int dayId, PlannedWorkoutDAL workout)
        {
            workout.WorkoutScheduleDayID = dayId;
            return await _workoutRepo.AddWorkoutToDayAsync(workout);
        }

        public async Task UpdateWorkoutAsync(PlannedWorkoutDAL workout)
        {
            await _workoutRepo.UpdateWorkoutAsync(workout);
            await _workoutRepo.SaveChangesAsync();
        }
            

        public async Task DeleteWorkoutAsync(int workoutId)
            => await _workoutRepo.DeleteWorkoutAsync(workoutId);

        public Task<PlannedWorkoutDAL> GetWorkoutByIdAsync(int id)
        {
            return _workoutRepo.GetWorkoutByIdAsync(id);
        }
    }
}