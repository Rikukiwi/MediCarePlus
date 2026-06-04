FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY . .
RUN find . -type d -name "obj" -exec rm -rf {} + 2>/dev/null; exit 0
RUN find . -type d -name "bin" -exec rm -rf {} + 2>/dev/null; exit 0
RUN dotnet restore "MediCarePlus.csproj"
RUN dotnet publish "MediCarePlus.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .
ENV ASPNETCORE_URLS=http://+:80
ENV ASPNETCORE_ENVIRONMENT=Production
ENV DOTNET_USE_POLLING_FILE_WATCHER=true
ENV ASPNETCORE_hostBuilder__reloadConfigOnChange=false
EXPOSE 80
ENTRYPOINT ["dotnet", "MediCarePlus.dll"]