# CP
Логика подсчета количества движений:
1) Перевести угловые скорости в углы.

   <img width="644" height="448" alt="image" src="https://github.com/user-attachments/assets/d19886b3-a3f2-4c28-86c0-a8dbf7450199" />  ->
   <img width="1197" height="448" alt="image" src="https://github.com/user-attachments/assets/9b2cbc6e-1c8a-49ce-b08b-2f6fd7c7cb5e" />

   
3) Отфильтровать полученный угловой сигнал.

   <img width="1197" height="448" alt="image" src="https://github.com/user-attachments/assets/3c14da19-d66c-46e9-8e0b-b29b542999bf" /> ->
   <img width="1011" height="448" alt="image" src="https://github.com/user-attachments/assets/0429723f-0924-4d8a-9c7f-edbdac4e277d" />

   
5) Подсчитать количество min/max отфильтрованного сигнала. Рассчитать количество движений по формуле:

   n = (Nmax + Nmin - 2)//2

Реализация логики - в файле "Prototype.ipynb"
