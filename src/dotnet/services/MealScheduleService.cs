using dotnet.DAL;
using dotnet.Repositories;

namespace dotnet.Services
{
    public class MealScheduleService : IMealScheduleService
    {
        private readonly IMealScheduleRepository _scheduleRepo;
        private readonly IMealScheduleDayRepository _dayRepo;
        private readonly IPlannedMealRepository _mealRepo;

        public MealScheduleService(
            IMealScheduleRepository scheduleRepo,
            IMealScheduleDayRepository dayRepo,
            IPlannedMealRepository mealRepo)
        {
            _scheduleRepo = scheduleRepo;
            _dayRepo = dayRepo;
            _mealRepo = mealRepo;
        }

        public async Task<List<MealScheduleDAL>> GetSchedulesForUserAsync(int userId)
        {
            return await _scheduleRepo.GetAllByUserIdAsync(userId);
        }

        public async Task<MealScheduleDAL?> GetScheduleByIdAsync(int scheduleId)
        {
            return await _scheduleRepo.GetByIdAsync(scheduleId);
        }

        public async Task<MealScheduleDAL> CreateScheduleAsync(int userId, string title)
        {
            var schedule = new MealScheduleDAL
            {
                UserID = userId,
                Title = title,
                CreatedAt = DateTime.UtcNow,
                Days = new List<MealScheduleDayDAL>()
            };

            // Add 7 days (0 = Monday, 6 = Sunday)
            for (int i = 0; i < 7; i++)
            {
                schedule.Days.Add(new MealScheduleDayDAL
                {
                    DayOfWeek = i,
                    PlannedMeals = new List<PlannedMealDAL>()
                });
            }

            await _scheduleRepo.CreateAsync(schedule);
            return schedule;
        }

        public async Task UpdateScheduleTitleAsync(int scheduleId, string newTitle)
        {
            await _scheduleRepo.UpdateScheduleTitleAsync(scheduleId, newTitle);
        }

        public async Task DeleteScheduleAsync(int scheduleId)
        {
            var schedule = await _scheduleRepo.GetByIdAsync(scheduleId);
            if (schedule != null)
            {
                await _scheduleRepo.DeleteAsync(schedule);
            }
        }

        public async Task<List<PlannedMealDAL>> GetMealsForDayAsync(int dayId)
        {
            var day = await _dayRepo.GetByIdAsync(dayId);
            return day?.PlannedMeals?.ToList() ?? new List<PlannedMealDAL>();
        }

        public async Task<PlannedMealDAL> AddMealToDayAsync(int dayId, PlannedMealDAL meal)
        {
            meal.MealScheduleDayID = dayId;
            await _mealRepo.AddAsync(meal);
            await _mealRepo.SaveChangesAsync();
            return meal;
        }

        public async Task UpdateMealAsync(PlannedMealDAL meal)
        {
            await _mealRepo.UpdateAsync(meal);
            await _mealRepo.SaveChangesAsync();
        }

        public async Task DeleteMealAsync(int mealId)
        {
            var meal = await _mealRepo.GetByIdAsync(mealId);
            if (meal != null)
            {
                await _mealRepo.DeleteAsync(meal);
                await _mealRepo.SaveChangesAsync();
            }
        }

        public async Task SetActiveScheduleAsync(int scheduleId)
        {
            await _scheduleRepo.SetActiveScheduleAsync(scheduleId);
        }

        public async Task ToggleCheatDayAsync(int dayId)
        {
            await _dayRepo.ToggleCheatDayAsync(dayId);
        }

        public async Task LogMealAsync(int mealId, MealStatus status)
        {
            await _scheduleRepo.LogMealAsync(mealId, status);
        }

        public async Task<List<MealLog>> GetWeeklyLogsAsync(int userId)
        {
            return await _scheduleRepo.GetWeeklyLogsAsync(userId);
        }

        public async Task<MealScheduleDayDAL> GetDayAsync(int dayId)
        {
            return await _dayRepo.GetDayAsync(dayId);
        }
    }
}
