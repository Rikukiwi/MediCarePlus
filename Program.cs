using MediCarePlus.Data;

var builder = WebApplication.CreateBuilder(args);

// ── Dang ky dich vu ──────────────────────────────────────────
builder.Services.AddControllersWithViews();

// Dang ky DatabaseHelper de inject vao Controllers
builder.Services.AddScoped<DatabaseHelper>();

builder.Services.AddSession(options =>
{
    options.IdleTimeout      = TimeSpan.FromMinutes(60);
    options.Cookie.HttpOnly  = true;
    options.Cookie.IsEssential = true;
});

// ── Cau hinh pipeline ────────────────────────────────────────
var app = builder.Build();

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // XOA dong nay - khong dung HTTPS tren Render
    // app.UseHsts();
}

// XOA dong nay luon
// app.UseHttpsRedirection();

app.UseStaticFiles();
app.UseRouting();
app.UseSession();
app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();