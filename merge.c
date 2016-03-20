/* FIXME : introduce elegant ways to reuse */
#include "swap.c"

List *find_node(List *head, int index)
{
    List *p = head;
    int i = 0;

    while (i < index) {
        p = p->next;
        i++;
    }
    return p;
}

void merge_sort(List *head_l, List *head_r, int length_l, int length_r)
{
    int i, j;
    int tmp;
    List *pre;
    List *l = head_l;
    List *r = head_r;

    if(length_l > 1) {
        i = length_l / 2;
        j = length_l - i;
        r = find_node(head_l, i);
        merge_sort(head_l, r, i, j);
    }

    if(length_r > 1) {
        i = length_r / 2;
        j = length_r - i;
        r = find_node(head_r, i);
        merge_sort(head_r, r, i, j);
    }

    if ((length_l >= 1) && (length_r >= 1)) {
        for(i = 0; i < length_l; i++) {
            tmp = l->value;
            pre = NULL;
            r = head_r;
            for(j = 0; j < length_r; j++) {
                if(!pre) {
                    if (tmp > r->value) {
                        pre = r;
                        l->value = r->value;
                        r->value = tmp;
                    }
                } else {
                    if (tmp > r->value) {
                        pre->value = r->value;
                        r->value = tmp;
                        pre = r;
                    }
                }
                r = r->next;
            }
            l = l->next;
        }
    }
}
