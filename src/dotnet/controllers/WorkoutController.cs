using dotnet.Models;
using Microsoft.AspNetCore.Mvc;

namespace dotnet.Controllers;

[ApiController]
[Route("api/workouts")]

public class WorkoutController : ControllerBase
{
    private static List<Workout> workouts = new List<Workout>();

    [HttpGet]
    public ActionResult<IEnumerable<Workout>> Get()
    {
        return Ok(workouts);
    }

    [HttpPost]
    public ActionResult<Workout> Post(Workout workout)
    {
        if (workout == null)
        {
            return BadRequest();
        }    

        workouts.Add(workout);
        return Ok(workout);
    }

    [HttpPut("{id}")]
    public ActionResult<Workout> Put(int id, Workout workout)
    {
        if (workout == null)
        {
            return BadRequest();
        }

        var existingWorkout = workouts.Find(w => w.Id == id);
        if (existingWorkout == null)
        {
            return NotFound();
        }

        existingWorkout.Distance = workout.Distance;
        existingWorkout.StartDate = workout.StartDate;
        existingWorkout.EndDate = workout.EndDate;
        existingWorkout.CategoryId = workout.CategoryId;

        return Ok(existingWorkout);
        }

    [HttpDelete]
    public ActionResult<Workout> Delete(int id)
    {
        var existingWorkout = workouts.Find(w => w.Id == id);
        if (existingWorkout == null)
        {
            return NotFound();
        }

        workouts.Remove(existingWorkout);
        return Ok(existingWorkout);
    }
}