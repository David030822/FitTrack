using dotnet.DAL;
using dotnet.Data;
using Microsoft.EntityFrameworkCore;

namespace dotnet.Repositories
{
    public class MealScheduleDayRepository : IMealScheduleDayRepository
    {
        private readonly AppDbContext _context;

        public MealScheduleDayRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<MealScheduleDayDAL?> GetByIdAsync(int id)
        {
            return await _context.MealScheduleDays
                .Include(d => d.PlannedMeals)
                .FirstOrDefaultAsync(d => d.MealScheduleDayID == id);
        }

        public async Task<List<MealScheduleDayDAL>> GetByScheduleIdAsync(int scheduleId)
        {
            return await _context.MealScheduleDays
                .Include(d => d.PlannedMeals)
                .Where(d => d.MealScheduleID == scheduleId)
                .ToListAsync();
        }

        public async Task AddAsync(MealScheduleDayDAL day)
        {
            await _context.MealScheduleDays.AddAsync(day);
        }

        public async Task ToggleCheatDayAsync(int dayId)
        {
            var day = await _context.MealScheduleDays.FindAsync(dayId);
            if (day == null) throw new Exception("Day not found");

            day.IsCheatDay = !day.IsCheatDay;
            await _context.SaveChangesAsync();
        }

        public async Task SaveChangesAsync()
        {
            await _context.SaveChangesAsync();
        }

        public async Task<MealScheduleDayDAL> GetDayAsync(int dayId)
        {
            return await _context.MealScheduleDays
                .Include(d => d.PlannedMeals)
                .FirstOrDefaultAsync(d => d.MealScheduleDayID == dayId)
                ?? throw new Exception("Day not found");
        }
    }
}
