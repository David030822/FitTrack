using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace dotnet.Migrations
{
    /// <inheritdoc />
    public partial class UpdateGoalCheckedTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_GoalChecked_Goal_GoalID",
                table: "GoalChecked");

            migrationBuilder.DropForeignKey(
                name: "FK_GoalChecked_Goals_GoalDALGoalID",
                table: "GoalChecked");

            migrationBuilder.DropTable(
                name: "Goal");

            migrationBuilder.DropIndex(
                name: "IX_GoalChecked_GoalDALGoalID",
                table: "GoalChecked");

            migrationBuilder.DropColumn(
                name: "GoalDALGoalID",
                table: "GoalChecked");

            migrationBuilder.AddForeignKey(
                name: "FK_GoalChecked_Goals_GoalID",
                table: "GoalChecked",
                column: "GoalID",
                principalTable: "Goals",
                principalColumn: "GoalID",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_GoalChecked_Goals_GoalID",
                table: "GoalChecked");

            migrationBuilder.AddColumn<int>(
                name: "GoalDALGoalID",
                table: "GoalChecked",
                type: "integer",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "Goal",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    IsCompleted = table.Column<bool>(type: "boolean", nullable: false),
                    Text = table.Column<string>(type: "text", nullable: false),
                    UserId = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Goal", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_GoalChecked_GoalDALGoalID",
                table: "GoalChecked",
                column: "GoalDALGoalID");

            migrationBuilder.AddForeignKey(
                name: "FK_GoalChecked_Goal_GoalID",
                table: "GoalChecked",
                column: "GoalID",
                principalTable: "Goal",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_GoalChecked_Goals_GoalDALGoalID",
                table: "GoalChecked",
                column: "GoalDALGoalID",
                principalTable: "Goals",
                principalColumn: "GoalID");
        }
    }
}
