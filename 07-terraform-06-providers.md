# Домашнее задание к занятию "17. Написание собственных провайдеров для Terraform."
## Задача 1
1.
[data_source](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/provider/provider.go#L419)</br>
[resource](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/provider/provider.go#L944)
2.
- С каким другим параметром конфликтует name?</br>
**name** конфликтует с **name_prefix**
  (https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L83)
```go
		"name": {
			Type:          schema.TypeString,
			Optional:      true,
			Computed:      true,
			ForceNew:      true,
			ConflictsWith: []string{"name_prefix"},
		},
```
- Какая максимальная длина имени?</br>
Длина ограничена регулярным выражением. 75 или 80 символов (латинские буквы, цифры, подчеркивание "_", минус "-")
в зависимости от наличия флага "fifo_queue" (булевый параметр ресурса _aws_sqs_queue_)
  (https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L431)
- Какому регулярному выражению должно подчиняться имя?</br>
```go
		if fifoQueue {
			re = regexp.MustCompile(`^[a-zA-Z0-9_-]{1,75}\.fifo$`)
		} else {
			re = regexp.MustCompile(`^[a-zA-Z0-9_-]{1,80}$`)
		}

		if !re.MatchString(name) {
			return fmt.Errorf("invalid queue name: %s", name)
		}
```