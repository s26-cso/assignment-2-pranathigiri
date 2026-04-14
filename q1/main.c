#include <stdio.h>
#include <stdlib.h>

struct node{
    int val;
    struct node* left;
    struct node* right;
};

struct node* make_node(int val);

struct node* insert(struct node* root,int val);

struct node* get(struct node* root,int val);

int getAtMost(int val,struct node* root);

int main(){

    struct node* root=NULL;

    // inserting values into tree

    root=insert(root,10);
    root=insert(root,5);
    root=insert(root,20);
    root=insert(root,3);
    root=insert(root,7);
    root=insert(root,25);
    root=insert(root,18);

    struct node* result=get(root,18);

    if(result){
        printf("get(18)=%d\n",result->val);
    }
    else
        printf("get(18)=NULL\n");

    result=get(root,1);

    if(result){
        printf("get(1)=%d\n",result->val);
    }
    else
        printf("get(1)=NULL\n");

    printf("getAtMost(7)=%d\n",getAtMost(7,root));
    printf("getAtMost(20)=%d\n",getAtMost(20,root));
    printf("getAtMost(11)=%d\n",getAtMost(11,root));

    return 0;
    
}