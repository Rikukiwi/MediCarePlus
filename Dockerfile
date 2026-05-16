FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY ["MC/MediCarePlus.csproj", "MC/"]
RUN dotnet restore "MC/MediCarePlus.csproj"

COPY . .

WORKDIR "/src/MC"

RUN dotnet publish "MediCarePlus.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

COPY --from=build /app/publish .

ENTRYPOINT ["dotnet", "MediCarePlus.dll"]