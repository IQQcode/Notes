根据线程的休眠来排序

```java
class SortThread extends Thread{

    private int value;
    public SortThread(int value) {
        this.value = value;
    }

    @Override
    public void run() {
        try {
            Thread.sleep(value);
            System.out.println(value);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}

public class Sort6_ThreadSleepSort {
    public static void main(String[] args) {
        int[] arr = {10, 100, 30, 50, 2, 60};
        for (int i = 0; i < arr.length; i++) {
            new SortThread(arr[i]).start();
        }
    }
}
```

