using dotnet.DAL;
using dotnet.Data;
using Microsoft.EntityFrameworkCore;

namespace dotnet.Repositories
{
    public class WorkoutScheduleDayRepository : IWorkoutScheduleDayRepository
    {
        private readonly AppDbContext _context;

        public WorkoutScheduleDayRepository(AppDbContext context)
        {
            _context = context;
        }

        public Task<List<WorkoutScheduleDayDAL>> GetDaysForScheduleAsync(int scheduleId)
        {
            return _context.WorkoutScheduleDays
                .Include(d => d.PlannedWorkouts)
                .Where(d => d.WorkoutScheduleID == scheduleId)
                .ToListAsync();
        }

        public async Task<WorkoutScheduleDayDAL> GetDayAsync(int dayId)
        {
            return await _context.WorkoutScheduleDays
                .Include(d => d.PlannedWorkouts)
                .FirstOrDefaultAsync(d => d.WorkoutScheduleDayID == dayId);
        }

        public async Task ToggleRestDayAsync(int dayId)
        {
            var day = await _context.WorkoutScheduleDays.FindAsync(dayId);
            if (day != null)
            {
                day.IsRestDay = !day.IsRestDay;
                await _context.SaveChangesAsync();
            }
        }

        public async Task UpdateDayAsync(WorkoutScheduleDayDAL day)
        {
            _context.WorkoutScheduleDays.Update(day);
            await _context.SaveChangesAsync();
        }

        public async Task SaveChangesAsync()
        {
            await _context.SaveChangesAsync();
        }
    }
}