<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Data Visualization</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .chart-container {
            transition: all 0.3s ease;
        }

        .chart-container:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }

        .data-card {
            transition: all 0.3s ease;
        }

        .data-card:hover {
            transform: scale(1.03);
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.1);
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .animate-fade-in {
            animation: fadeIn 0.6s ease-out forwards;
        }
    </style>
</head>

<body class="bg-gray-50 min-h-screen">
    <div class="container mx-auto px-4 py-8">
        <header class="text-center mb-12 animate-fade-in" style="animation-delay: 0.1s;">
            <h1 class="text-4xl font-bold text-indigo-700 mb-3">Historical Data Analysis</h1>
            <p class="text-xl text-gray-600 max-w-2xl mx-auto">
                Visualizing data accumulation over different time periods
            </p>
        </header>

        <div class="mb-12">
            <div class="chart-container bg-white p-6 rounded-xl shadow-md animate-fade-in"
                style="animation-delay: 0.2s;">
                <h2 class="text-2xl font-semibold text-gray-800 mb-4">Query Performance Over Time</h2>
                <div class="h-96">
                    <canvas id="performanceChart"></canvas>
                </div>
            </div>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-12">
            <div class="data-card bg-white p-6 rounded-xl shadow-md flex flex-col animate-fade-in"
                style="animation-delay: 0.4s;">
                <div class="flex items-center justify-between mb-3">
                    <h3 class="text-lg font-medium text-gray-700">20 Years</h3>
                    <span class="px-3 py-1 bg-indigo-100 text-indigo-800 rounded-full text-sm font-medium">Oldest</span>
                </div>
                <p class="text-3xl font-bold text-indigo-600 mb-2">34,738</p>
                <p class="text-gray-500 text-sm">Data points collected over 20 years</p>
            </div>

            <div class="data-card bg-white p-6 rounded-xl shadow-md flex flex-col animate-fade-in"
                style="animation-delay: 0.5s;">
                <div class="flex items-center justify-between mb-3">
                    <h3 class="text-lg font-medium text-gray-700">10 Years</h3>
                    <span
                        class="px-3 py-1 bg-green-100 text-green-800 rounded-full text-sm font-medium">Significant</span>
                </div>
                <p class="text-3xl font-bold text-green-600 mb-2">175,534</p>
                <p class="text-gray-500 text-sm">5x more data than 20 years</p>
            </div>

            <div class="data-card bg-white p-6 rounded-xl shadow-md flex flex-col animate-fade-in"
                style="animation-delay: 0.6s;">
                <div class="flex items-center justify-between mb-3">
                    <h3 class="text-lg font-medium text-gray-700">5 Years</h3>
                    <span class="px-3 py-1 bg-yellow-100 text-yellow-800 rounded-full text-sm font-medium">Recent</span>
                </div>
                <p class="text-3xl font-bold text-yellow-600 mb-2">425,792</p>
                <p class="text-gray-500 text-sm">12x more data than 20 years</p>
            </div>

            <div class="data-card bg-white p-6 rounded-xl shadow-md flex flex-col animate-fade-in"
                style="animation-delay: 0.7s;">
                <div class="flex items-center justify-between mb-3">
                    <h3 class="text-lg font-medium text-gray-700">1 Year</h3>
                    <span class="px-3 py-1 bg-red-100 text-red-800 rounded-full text-sm font-medium">Latest</span>
                </div>
                <p class="text-3xl font-bold text-red-600 mb-2">577,976</p>
                <p class="text-gray-500 text-sm">16.6x more data than 20 years</p>
            </div>
        </div>

        <div class="bg-white p-6 rounded-xl shadow-md animate-fade-in" style="animation-delay: 0.8s;">
            <h2 class="text-2xl font-semibold text-gray-800 mb-4">Key Insights</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="bg-indigo-50 p-5 rounded-lg">
                    <h3 class="font-medium text-indigo-700 mb-2">Exponential Growth</h3>
                    <p class="text-gray-700">The data shows exponential growth in collection rates, with the most recent
                        year accounting for more data than the first 15 years combined.</p>
                </div>
                <div class="bg-green-50 p-5 rounded-lg">
                    <h3 class="font-medium text-green-700 mb-2">Acceleration Point</h3>
                    <p class="text-gray-700">The most significant acceleration occurred between 10 and 5 years ago,
                        where data collection increased by 250%.</p>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Sample data structure - replace with your actual data
            const queryData = {
                "2025-06-21": {
                    "q1": {
                        "avg_cpu_ms": 369208.05,
                        "avg_elapsed_ms": 712159.09,
                        "avg_logical_reads": 6344.00
                    },
                    "q2": {
                        "avg_cpu_ms": 100093.55,
                        "avg_elapsed_ms": 164826.09,
                        "avg_logical_reads": 649.91
                    }
                },
                "2025-06-20": {
                    "q1": {
                        "avg_cpu_ms": 350000.00,
                        "avg_elapsed_ms": 700000.00,
                        "avg_logical_reads": 6000.00
                    },
                    "q2": {
                        "avg_cpu_ms": 95000.00,
                        "avg_elapsed_ms": 160000.00,
                        "avg_logical_reads": 600.00
                    }
                }
                // Add more days as needed
            };

            // Extract dates for labels
            const dates = Object.keys(queryData);
            
            // Prepare datasets for each metric
            const datasets = [];
            const queryKeys = Object.keys(queryData[dates[0]]);
            
            queryKeys.forEach(queryKey => {
                datasets.push({
                    label: `${queryKey} - CPU Time (ms)`,
                    data: dates.map(date => queryData[date][queryKey].avg_cpu_ms),
                    borderColor: `rgba(${Math.floor(Math.random() * 255)}, ${Math.floor(Math.random() * 255)}, ${Math.floor(Math.random() * 255)}, 1)`,
                    backgroundColor: `rgba(${Math.floor(Math.random() * 255)}, ${Math.floor(Math.random() * 255)}, ${Math.floor(Math.random() * 255)}, 0.2)`,
                    borderWidth: 2,
                    tension: 0.1,
                    yAxisID: 'y'
                });
                
                datasets.push({
                    label: `${queryKey} - Elapsed Time (ms)`,
                    data: dates.map(date => queryData[date][queryKey].avg_elapsed_ms),
                    borderColor: `rgba(${Math.floor(Math.random() * 255)}, ${Math.floor(Math.random() * 255)}, ${Math.floor(Math.random() * 255)}, 1)`,
                    backgroundColor: `rgba(${Math.floor(Math.random() * 255)}, ${Math.floor(Math.random() * 255)}, ${Math.floor(Math.random() * 255)}, 0.2)`,
                    borderWidth: 2,
                    tension: 0.1,
                    yAxisID: 'y'
                });
                
                datasets.push({
                    label: `${queryKey} - Logical Reads`,
                    data: dates.map(date => queryData[date][queryKey].avg_logical_reads),
                    borderColor: `rgba(${Math.floor(Math.random() * 255)}, ${Math.floor(Math.random() * 255)}, ${Math.floor(Math.random() * 255)}, 1)`,
                    backgroundColor: `rgba(${Math.floor(Math.random() * 255)}, ${Math.floor(Math.random() * 255)}, ${Math.floor(Math.random() * 255)}, 0.2)`,
                    borderWidth: 2,
                    tension: 0.1,
                    yAxisID: 'y1'
                });
            });

            const chartData = {
                labels: dates,
                datasets: datasets
            };

            // Performance Chart
            const perfCtx = document.getElementById('performanceChart').getContext('2d');
            const performanceChart = new Chart(perfCtx, {
                type: 'line',
                data: chartData,
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'top',
                            labels: {
                                boxWidth: 12
                            }
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    return `${context.dataset.label}: ${context.raw.toFixed(2)}`;
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            type: 'linear',
                            display: true,
                            position: 'left',
                            title: {
                                display: true,
                                text: 'Time (ms)'
                            }
                        },
                        y1: {
                            type: 'linear',
                            display: true,
                            position: 'right',
                            title: {
                                display: true,
                                text: 'Logical Reads'
                            },
                            grid: {
                                drawOnChartArea: false
                            }
                        },
                        x: {
                            title: {
                                display: true,
                                text: 'Date'
                            }
                        }
                    },
                    elements: {
                        line: {
                            tension: 0.4,
                            borderWidth: 2
                        },
                        point: {
                            radius: 4,
                            hoverRadius: 6
                        }
                    },
                    animation: {
                        duration: 1500,
                        easing: 'easeOutQuart'
                    }
                }
            });

            // Add animation to cards
            const cards = document.querySelectorAll('.data-card');
            cards.forEach((card, index) => {
                card.style.animationDelay = `${0.4 + index * 0.1}s`;
            });
        });
    </script>
</body>

</html>