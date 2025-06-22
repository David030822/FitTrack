using dotnet.DAL;
using dotnet.Data;
using Microsoft.EntityFrameworkCore;

namespace dotnet.Repositories
{
    public class MealScheduleRepository : IMealScheduleRepository
    {
        private readonly AppDbContext _context;

        public MealScheduleRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<List<MealScheduleDAL>> GetAllByUserIdAsync(int userId)
        {
            return await _context.MealSchedules
                .Include(s => s.Days)
                .ThenInclude(d => d.PlannedMeals)
                .Where(s => s.UserID == userId)
                .ToListAsync();
        }

        public async Task<MealScheduleDAL?> GetByIdAsync(int id)
        {
            return await _context.MealSchedules
                .Include(s => s.Days)
                    .ThenInclude(d => d.PlannedMeals)
                .FirstOrDefaultAsync(s => s.MealScheduleID == id);
        }

        public async Task<MealScheduleDAL> CreateAsync(MealScheduleDAL schedule)
        {
            _context.MealSchedules.Add(schedule);
            await _context.SaveChangesAsync();
            return schedule;
        }

        public async Task UpdateScheduleTitleAsync(int scheduleId, string newTitle)
        {
            var schedule = await _context.MealSchedules.FindAsync(scheduleId);
            if (schedule == null)
                throw new Exception("Schedule not found");

            schedule.Title = newTitle;
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(MealScheduleDAL schedule)
        {
            _context.MealSchedules.Remove(schedule);
            await _context.SaveChangesAsync();
        }

        public async Task SetActiveScheduleAsync(int scheduleId)
        {
            var target = await _context.MealSchedules.FindAsync(scheduleId);
            if (target == null) throw new Exception("Schedule not found");

            var userId = target.UserID;
            var allSchedules = _context.MealSchedules.Where(s => s.UserID == userId);
            await allSchedules.ForEachAsync(s => s.IsActive = s.MealScheduleID == scheduleId);
            await _context.SaveChangesAsync();
        }

        public async Task LogMealAsync(int mealId, MealStatus status)
        {
            var log = new MealLog
            {
                MealId = mealId,
                Status = status,
                Date = DateTime.UtcNow
            };
            _context.MealLogs.Add(log);
            await _context.SaveChangesAsync();
        }

        public async Task<List<MealLog>> GetWeeklyLogsAsync(int userId)
        {
            var scheduleIds = await _context.MealSchedules
                .Where(s => s.UserID == userId)
                .Select(s => s.MealScheduleID)
                .ToListAsync();

            var mealIds = await _context.MealScheduleDays
                .Where(d => scheduleIds.Contains(d.MealScheduleID))
                .SelectMany(d => d.PlannedMeals.Select(pm => pm.PlannedMealID))
                .ToListAsync();

            var now = DateTime.UtcNow;
            var weekStart = now.Date.AddDays(-(int)now.DayOfWeek); // start of week
            var weekEnd = weekStart.AddDays(7);

            return await _context.MealLogs
                .Where(log => mealIds.Contains(log.MealId) && log.Date >= weekStart && log.Date < weekEnd)
                .ToListAsync();
        }

        public async Task SaveChangesAsync()
        {
            await _context.SaveChangesAsync();
        }
    }
}
