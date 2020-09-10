### Input

```java
Scanner in = new Scanner(System.in);
String[] num = null;

num = in.nextLine().split(" ");

int[] nums = new int[num.length];
for (int i = 0; i < num.length; i++) {
    nums[i] = Integer.parseInt(num[i]);
}

int target = in.nextInt();
```

### 三数相近之和

```java
import java.util.*;

public class Main {
    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        String[] num = null;
        num = in.nextLine().split(" ");
        int[] nums = new int[num.length];
        for (int i = 0; i < num.length; i++) {
            nums[i] = Integer.parseInt(num[i]);
        }
        int target = in.nextInt();
        System.out.println(threeSumClosest(nums, target));
    }

    private static int threeSumClosest(int[] nums, int target) {
        Arrays.sort(nums);
        int ans = nums[0] + nums[1] + nums[2];
        for (int i = 0; i < nums.length; i++) {
            int start = i + 1, end = nums.length - 1;
            while (start < end) {
                int sum = nums[i] + nums[start] + nums[end];
                if (Math.abs(sum - target) < Math.abs(ans - target)) ans = sum;

                if (sum == target) {
                    return ans;
                } else if (sum < target) {
                    start++;
                } else {
                    end--;
                }
            }
        }
        return ans;
    }
}
```

