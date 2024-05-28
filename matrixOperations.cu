#include <iostream>
#include <stdlib.h>
#include <vector>
#include <ctime>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

using namespace std;

vector<int> generateVector(int upLim, int downLim, int n)
{
    vector<int> vector;

    for (int i = 0; i < n; i++)
    {
        vector.push_back(downLim + rand() % (upLim - downLim));
    }

    cout << "Vector creado: " << endl;

    return vector;
}

void matrizResultante(int** matriz1, int** matriz2, int n)
{
    clock_t init, end;
    double timeExec;

    int** resultado = new int*[n];

    init = clock();

    for (int i = 0; i < n; ++i)
    {
        resultado[i] = new int[n];
    }
    for (int i = 0; i < n; ++i)
    {
        for (int j = 0; j < n; ++j)
        {
            resultado[i][j] = 0;
            for (int k = 0; k < n; ++k)
            {
                resultado[i][j] += matriz1[i][k] * matriz2[k][j];
            }
        }
    }

    end = clock();

    timeExec = ((double)(end - init)) / CLOCKS_PER_SEC;

    cout << "Tiempo total de procesamiento: " << timeExec << endl;
}

// Función para crear una matriz n x n con números aleatorios
int **crearMatriz(int n)
{
    // Reservar memoria para una matriz dinámica de n x n
    int **matriz = new int *[n];
    for (int i = 0; i < n; ++i)
    {
        matriz[i] = new int[n];
    }

    // Llenar la matriz con números aleatorios
    for (int i = 0; i < n; ++i)
    {
        for (int j = 0; j < n; ++j)
        {
            matriz[i][j] = std::rand() % 100; // Números aleatorios entre 0 y 99
        }
    }

    cout << "Matriz creada: " << endl;

    return matriz;
}


__global__ void matrixMultiplication(int** A, int** B, int n) {

    // Reservar memoria para una matriz dinámica de n x n
    int **matriz = new int *[n];
    for (int i = 0; i < n; ++i)
    {
        matriz[i] = new int[n];
    }

    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    if (row < n && col < n) {
        int sum = 0;
        for (int i = 0; i < n; i++) {
            sum += A[row][i] * B[i][col];
        }
        matriz[row][col] = sum;
    }
}