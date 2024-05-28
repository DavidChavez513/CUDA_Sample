#include <iostream>
#include <vector>
#include "matrixOperations.cu"

using namespace std;

int main() {

    srand(time(nullptr));

    int n = 5000;

    int** matrizA = crearMatriz(n);
    int** matrizB = crearMatriz(n);

    matrizResultante(matrizA, matrizB, n);


    int** mtxCudaA = crearMatriz(n);
    int** mtxCudaB = crearMatriz(n);

    cudaMalloc(&mtxCudaA, n * n * sizeof(int));
    cudaMalloc(&mtxCudaB, n * n * sizeof(int));

    cudaMemcpy(mtxCudaA, matrizA, n * n * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(mtxCudaB, matrizB, n * n * sizeof(int), cudaMemcpyHostToDevice);

    clock_t init, end;
    double timeExec;

    init = clock();
    matrixMultiplication <<< 1, 256 >>> (mtxCudaA, mtxCudaB, n);
    cudaDeviceSynchronize();
    end = clock();

    timeExec = ((double)(end - init)) / CLOCKS_PER_SEC;

    cout << "Tiempo total de procesamiento en CUDA: " << timeExec << endl;

    return 0;
}

