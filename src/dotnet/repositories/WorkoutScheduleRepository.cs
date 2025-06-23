using dotnet.DAL;
using dotnet.Data;
using Microsoft.EntityFrameworkCore;

namespace dotnet.Repositories
{
    public class WorkoutScheduleRepository : IWorkoutScheduleRepository
    {
        private readonly AppDbContext _context;

        public WorkoutScheduleRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<List<WorkoutScheduleDAL>> GetSchedulesForUserAsync(int userId)
        {
            return await _context.WorkoutSchedules
                .Include(s => s.Days)
                .ThenInclude(d => d.PlannedWorkouts)
                .Where(s => s.UserID == userId)
                .ToListAsync();
        }

        public async Task<WorkoutScheduleDAL> GetScheduleByIdAsync(int id)
        {
            return await _context.WorkoutSchedules
                .Include(s => s.Days)
                .ThenInclude(d => d.PlannedWorkouts)
                .FirstOrDefaultAsync(s => s.WorkoutScheduleID == id);
        }

        public async Task<WorkoutScheduleDAL> CreateScheduleAsync(WorkoutScheduleDAL schedule)
        {
            _context.WorkoutSchedules.Add(schedule);
            await _context.SaveChangesAsync();
            return schedule;
        }

        public async Task UpdateScheduleTitleAsync(int id, string newTitle)
        {
            var schedule = await _context.WorkoutSchedules.FindAsync(id);
            if (schedule != null)
            {
                schedule.Title = newTitle;
                await _context.SaveChangesAsync();
            }
        }

        public async Task DeleteScheduleAsync(int id)
        {
            var schedule = await _context.WorkoutSchedules.FindAsync(id);
            if (schedule != null)
            {
                _context.WorkoutSchedules.Remove(schedule);
                await _context.SaveChangesAsync();
            }
        }

        public async Task ToggleActiveScheduleAsync(int scheduleId)
        {
            var target = await _context.WorkoutSchedules.FindAsync(scheduleId);
            if (target == null) throw new Exception("Schedule not found");

            var userId = target.UserID;
            var allSchedules = _context.WorkoutSchedules.Where(s => s.UserID == userId);
            await allSchedules.ForEachAsync(s => s.IsActive = s.WorkoutScheduleID == scheduleId);
            await _context.SaveChangesAsync();
        }

        public async Task SaveChangesAsync()
        {
            await _context.SaveChangesAsync();
        }
    }
}