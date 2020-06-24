class Solution {
     public boolean isPalindrome(ListNode head) {
        if (head == null || head.next == null) {
            return true;
        }
        if (head.next.next == null) {
            return head.val == head.next.val;
        }
        // 1、找中间节点
        ListNode fast = head;
        ListNode slow = head;
        while (fast != null && fast.next != null) {
            fast = fast.next.next;
            slow = slow.next;
        }

        // 2、反转后半边的链表
        fast = reverse(slow);   // 用 fast 暂存后半链表，方便比较后还原

        // 3、比较两个链表，判断是相同
        ListNode preNode  = head;   // preNode  指向 前半链表表头
        ListNode lastNode = fast;   // lastNode 指向 后半链表表头
        boolean flag = true;        // 判断标志
        
        while (preNode != lastNode) {
            // 值不相等，修改flag, 退出循环
            if (preNode.val != lastNode.val) {
                flag = false;
                break;
            }
            // 检查完毕
            if (preNode.next == lastNode) {
                break;
            }
            preNode  = preNode.next;
            lastNode = lastNode.next;
        }
        // 4、还原链表
        reverse(fast);
        return flag;
    }
    /**
    *  反转链表
    */
    private ListNode reverse(ListNode node) {
        if (node == null || node.next == null ) {
            return node;
        }
        ListNode pre = null;
        ListNode cur = node;
        while (cur != null) {
            ListNode next = cur.next;
            cur.next = pre;
            pre = cur;
            cur = next;
        }
        return pre;
    }
}