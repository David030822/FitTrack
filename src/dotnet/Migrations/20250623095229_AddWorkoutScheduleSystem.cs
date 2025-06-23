using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace dotnet.Migrations
{
    /// <inheritdoc />
    public partial class AddWorkoutScheduleSystem : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "WorkoutSchedules",
                columns: table => new
                {
                    WorkoutScheduleID = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    UserID = table.Column<int>(type: "integer", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    IsActive = table.Column<bool>(type: "boolean", nullable: false),
                    Title = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_WorkoutSchedules", x => x.WorkoutScheduleID);
                    table.ForeignKey(
                        name: "FK_WorkoutSchedules_Users_UserID",
                        column: x => x.UserID,
                        principalTable: "Users",
                        principalColumn: "UserID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "WorkoutScheduleDays",
                columns: table => new
                {
                    WorkoutScheduleDayID = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    WorkoutScheduleID = table.Column<int>(type: "integer", nullable: false),
                    DayOfWeek = table.Column<int>(type: "integer", nullable: false),
                    IsRestDay = table.Column<bool>(type: "boolean", nullable: false),
                    StartTime = table.Column<TimeOnly>(type: "time without time zone", nullable: true),
                    WorkoutLabel = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_WorkoutScheduleDays", x => x.WorkoutScheduleDayID);
                    table.ForeignKey(
                        name: "FK_WorkoutScheduleDays_WorkoutSchedules_WorkoutScheduleID",
                        column: x => x.WorkoutScheduleID,
                        principalTable: "WorkoutSchedules",
                        principalColumn: "WorkoutScheduleID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "PlannedWorkouts",
                columns: table => new
                {
                    PlannedWorkoutID = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    WorkoutScheduleDayID = table.Column<int>(type: "integer", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: false),
                    Description = table.Column<string>(type: "text", nullable: true),
                    TargetMuscle = table.Column<string>(type: "text", nullable: false),
                    Sets = table.Column<int>(type: "integer", nullable: false),
                    Reps = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PlannedWorkouts", x => x.PlannedWorkoutID);
                    table.ForeignKey(
                        name: "FK_PlannedWorkouts_WorkoutScheduleDays_WorkoutScheduleDayID",
                        column: x => x.WorkoutScheduleDayID,
                        principalTable: "WorkoutScheduleDays",
                        principalColumn: "WorkoutScheduleDayID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_PlannedWorkouts_WorkoutScheduleDayID",
                table: "PlannedWorkouts",
                column: "WorkoutScheduleDayID");

            migrationBuilder.CreateIndex(
                name: "IX_WorkoutScheduleDays_WorkoutScheduleID",
                table: "WorkoutScheduleDays",
                column: "WorkoutScheduleID");

            migrationBuilder.CreateIndex(
                name: "IX_WorkoutSchedules_UserID",
                table: "WorkoutSchedules",
                column: "UserID");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "PlannedWorkouts");

            migrationBuilder.DropTable(
                name: "WorkoutScheduleDays");

            migrationBuilder.DropTable(
                name: "WorkoutSchedules");
        }
    }
}
