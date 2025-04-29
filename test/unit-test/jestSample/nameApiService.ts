import {AxiosInstance} from "axios";

export interface INameApiService {
  getFirstName(): Promise<string>;
}

export class NameApiService implements INameApiService{
  private MAX_LENGTH = 4;
  private readonly httpClient;
  private readonly url;

  public constructor(httpClient: AxiosInstance, url: string) {
    this.httpClient = httpClient;
    this.url = url;
  }

  public async getFirstName(): Promise<string> {
    const { data } = await this.httpClient.get(this.url);
    const firstName = data.first_name as string;

    if (firstName.length > this.MAX_LENGTH) {
      throw new Error("firstName is too long!");
    }

    return firstName;
  }
}
